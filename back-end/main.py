# main.py
import os
import uuid
import re
import subprocess
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base, Document
from datetime import datetime

# Import des modèles de traitement
import spacy
from PIL import Image
import pytesseract
import fitz  # PyMuPDF
import yake
import whisper

# Configurations
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# Tesseract
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# DB
engine = create_engine("sqlite:///db.sqlite3")
SessionLocal = sessionmaker(bind=engine)
Base.metadata.create_all(bind=engine)

# NLP
nlp = spacy.load("fr_core_news_sm")

# App
app = Flask(__name__)

# Fonctions de traitement (OCR, audio, mots-clés...)
def clean_text(text):
    text = re.sub(r"[^\w\s'éèàêâîôûçëïüù]", '', text)
    return re.sub(r'\s+', ' ', text).strip()

def ocr_image(path):
    img = Image.open(path)
    return pytesseract.image_to_string(img, lang="fra")

def ocr_pdf(path):
    text = ""
    doc = fitz.open(path)
    for page in doc:
        pix = page.get_pixmap(dpi=300)
        temp_img = "temp_page.png"
        pix.save(temp_img)
        text += pytesseract.image_to_string(Image.open(temp_img), lang="fra") + "\n"
        os.remove(temp_img)
    return text

def convert_mp3_to_wav(input_path, output_path):
    subprocess.run([r"C:\ffmpeg\ffmpeg-master-latest-win64-gpl-shared\bin\ffmpeg.exe", "-i", input_path, output_path, "-y"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def transcribe_audio(path):
    model = whisper.load_model("base")
    result = model.transcribe(path, language="fr")
    return result["text"]

def extract_keywords_yake(text, top_n=15): 
    kw_extractor = yake.KeywordExtractor(lan="fr", n=1, top=top_n)
    return kw_extractor.extract_keywords(text)

def filter_keywords(keywords):
    filtered = []
    for kw, score in keywords:
        doc = nlp(kw)
        token = doc[0]
        if token.pos_ in ["NOUN", "PROPN"] and not token.is_stop and len(token.text) > 1 and ' ' not in token.text:
            filtered.append((token.text, score))
    return filtered

# Route pour uploader un fichier
@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['file']
    uploader = request.form['uploader']
    ext = os.path.splitext(file.filename)[1].lower()
    file_id = str(uuid.uuid4())
    saved_path = os.path.join(UPLOAD_DIR, file_id + ext)

    file.save(saved_path)

    try:
        if ext == ".mp3":
            wav_path = os.path.join(UPLOAD_DIR, file_id + ".wav")
            convert_mp3_to_wav(saved_path, wav_path)
            raw_text = transcribe_audio(wav_path)
            os.remove(wav_path)
        elif ext == ".pdf":
            raw_text = ocr_pdf(saved_path)
        else:
            raw_text = ocr_image(saved_path)

        cleaned = clean_text(raw_text)
        keywords = filter_keywords(extract_keywords_yake(cleaned))
        kw_string = ", ".join([kw for kw, _ in keywords])

        # Ajout de la date d'upload
        upload_time = datetime.utcnow()

        # Insertion dans la base de données
        db = SessionLocal()
        doc = Document(
            filename=file.filename,
            uploader=uploader,
            content=cleaned,
            keywords=kw_string,
            uploaded_at=upload_time  # Date d'upload
        )
        db.add(doc)
        db.commit()
        db.refresh(doc)
        db.close()

        return jsonify({
            "message": "Fichier traité avec succès.",
            "filename": file.filename,
            "uploader": uploader,
            "keywords": [kw for kw, _ in keywords],
            "extracted_text": cleaned,  # Ajout du texte extrait
            "uploaded_at": upload_time.isoformat()  # Date et heure de l'upload
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)

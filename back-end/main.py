# main.py
import os
import uuid
import re
import subprocess
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base, Document, DocumentVersion  # Ajoute DocumentVersion ici
from datetime import datetime

# Import des modèles de traitement
import spacy
from PIL import Image
import pytesseract
import fitz  # PyMuPDF
import yake
import whisper
from flask_cors import CORS

# Application Flask
app = Flask(__name__)
# Appliquer CORS
CORS(app)

# Configurations
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# Tesseract
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
os.environ["TESSDATA_PREFIX"] = r"C:\tessdata" 

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
    os.environ["TESSDATA_PREFIX"] = r"C:\tessdata" 
    return pytesseract.image_to_string(img, lang="fra")

def ocr_pdf(path):
    text = ""
    print("Traitement du PDF...")
    doc = fitz.open(path)
    for page in doc:
        print(f"Traitement de la page {page.number + 1}...")
        pix = page.get_pixmap(dpi=300)
        print(f"Page {page.number + 1} traitée.")
        temp_img = "temp_page.png"
        print(f"Enregistrement de l'image temporaire : {temp_img}")
        pix.save(temp_img)
        print(f"Image temporaire enregistrée : {temp_img}")
        print(os.environ.get("TESSDATA_PREFIX"))
        print(f"Traitement de l'image avec Tesseract...")
        os.environ["TESSDATA_PREFIX"] = r"C:\tessdata" 
        text += pytesseract.image_to_string(Image.open(temp_img), lang="fra") + "\n"
        print(f"Texte extrait de la page {page.number + 1}.")
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

        # Date d'upload
        upload_time = datetime.utcnow()

        # Vérifier si le document existe déjà
        db = SessionLocal()
        doc = db.query(Document).filter(Document.filename == file.filename).first()

        if doc is None:
            # Si le document n'existe pas encore, on le crée
            doc = Document(
                filename=file.filename,
                uploader=uploader,
                content=cleaned,
                keywords=kw_string,
                uploaded_at=upload_time
            )
            db.add(doc)
            db.commit()
            db.refresh(doc)
        
        # Création de la nouvelle version
        last_version = db.query(DocumentVersion).filter(DocumentVersion.document_id == doc.id).order_by(DocumentVersion.version_number.desc()).first()
        version_number = last_version.version_number + 1 if last_version else 1
        
        new_version = DocumentVersion(
            document_id=doc.id,
            version_number=version_number,
            filename=file.filename,
            content=cleaned,
            keywords=kw_string,
            uploaded_at=upload_time
        )
        
        db.add(new_version)
        db.commit()
        db.refresh(new_version)

        db.close()

        return jsonify({
            "filename": file.filename,
            "uploader": uploader,
            "keywords": [kw for kw, _ in keywords],
            "extracted_text": cleaned,
            "uploaded_at": upload_time.isoformat(),
            "version_number": version_number
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/historique_user', methods=['GET'])
def historique_user():
    username = request.args.get('user')
    if not username:
        return jsonify({"error": "Paramètre 'user' manquant"}), 400

    db = SessionLocal()

    try:
        # Tous les documents uploadés par l'utilisateur
        docs = db.query(Document).filter(Document.uploader == username).all()

        historique = []
        for doc in docs:
            # Récupère toutes les versions du document
            versions = db.query(DocumentVersion).filter(DocumentVersion.document_id == doc.id).all()
            historique.append({
                "filename": doc.filename,
                "uploaded_at": doc.uploaded_at.isoformat(),
                "versions": [
                    {
                        "version_number": v.version_number,
                        "uploaded_at": v.uploaded_at.isoformat()
                    } for v in versions
                ]
            })

        db.close()
        return jsonify({"user": username, "documents": historique})

    except Exception as e:
        db.close()
        return jsonify({"error": str(e)}), 500

@app.route('/toutavoir', methods=['GET'])
def tout_avoir():
    db = SessionLocal()

    try:
        docs = db.query(Document).all()
        result = []

        for doc in docs:
            versions = db.query(DocumentVersion).filter(DocumentVersion.document_id == doc.id).all()
            result.append({
                "filename": doc.filename,
                "uploader": doc.uploader,
                "uploaded_at": doc.uploaded_at.isoformat(),
                "keywords": doc.keywords,
                "versions": [
                    {
                        "version_number": v.version_number,
                        "uploaded_at": v.uploaded_at.isoformat()
                    } for v in versions
                ]
            })

        db.close()
        return jsonify(result)

    except Exception as e:
        db.close()
        return jsonify({"error": str(e)}), 500

@app.route('/versions_document', methods=['GET'])
def versions_document():
    filename = request.args.get('filename')

    if not filename:
        return jsonify({"error": "Paramètre 'filename' requis"}), 400

    db = SessionLocal()

    try:
        doc = db.query(Document).filter(Document.filename == filename).first()
        if not doc:
            db.close()
            return jsonify({"error": "Document non trouvé"}), 404

        versions = db.query(DocumentVersion).filter(DocumentVersion.document_id == doc.id).order_by(DocumentVersion.version_number).all()
        
        result = {
            "filename": doc.filename,
            "uploader": doc.uploader,
            "versions": [
                {
                    "version_number": v.version_number,
                    "uploaded_at": v.uploaded_at.isoformat(),
                    "keywords": v.keywords
                } for v in versions
            ]
        }

        db.close()
        return jsonify(result)

    except Exception as e:
        db.close()
        return jsonify({"error": str(e)}), 500

@app.route('/recherche_motscles', methods=['POST'])
def recherche_motscles():
    data = request.get_json()
    keywords = data.get("keywords", [])

    if not keywords or not isinstance(keywords, list):
        return jsonify({"error": "Envoyez une liste de mots-clés via 'keywords'"}), 400

    db = SessionLocal()
    try:
        result = []
        docs = db.query(Document).all()

        for doc in docs:
            doc_keywords = [kw.strip().lower() for kw in doc.keywords.split(",")]
            if any(kw.lower() in doc_keywords for kw in keywords):
                result.append({
                    "filename": doc.filename,
                    "uploader": doc.uploader,
                    "uploaded_at": doc.uploaded_at.isoformat(),
                    "keywords": doc.keywords
                })

        db.close()
        return jsonify(result)

    except Exception as e:
        db.close()
        return jsonify({"error": str(e)}), 500

engine = create_engine("sqlite:///db.sqlite3")
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

# Récupérer tous les documents de la table
documents = db.query(Document).all()

# Afficher les documents
for doc in documents:
    print(f"ID: {doc.id}, Filename: {doc.filename}, Uploader: {doc.uploader}, Keywords: {doc.keywords}, Uploaded At: {doc.uploaded_at}")

# Fermer la session
db.close()
if __name__ == '__main__':
    app.run(debug=True)

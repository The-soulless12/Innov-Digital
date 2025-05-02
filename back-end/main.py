import spacy
from PIL import Image
import pytesseract
import fitz
import os
import re
import yake
import whisper
import subprocess

nlp = spacy.load("fr_core_news_sm")

pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

def clean_text(text):
    text = re.sub(r'[^\w\s\'éèàêâîôûçëïüù]', '', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def ocr_image(path):
    img = Image.open(path)
    return pytesseract.image_to_string(img, lang="fra")

def ocr_pdf(path):
    text = ""
    doc = fitz.open(path)
    for page in doc:
        pix = page.get_pixmap(dpi=300)
        img_path = "temp_page.png"
        pix.save(img_path)
        text += pytesseract.image_to_string(Image.open(img_path), lang="fra") + "\n"
        os.remove(img_path)
    return text

def extract_keywords_yake(text, top_n=30): 
    kw_extractor = yake.KeywordExtractor(lan="fr", n=1, top=top_n)
    return kw_extractor.extract_keywords(text)

def filter_keywords(keywords):
    filtered = []
    for kw, score in keywords:
        doc = nlp(kw)
        token = doc[0]
        if (
            token.pos_ in ["NOUN", "PROPN"] and  
            not token.is_stop and                
            len(token.text) > 1 and              
            ' ' not in token.text                
        ):
            filtered.append((token.text, score))
    return filtered

def convert_mp3_to_wav(input_path, output_path):
    subprocess.run([r"C:\ffmpeg\ffmpeg-master-latest-win64-gpl-shared\bin\ffmpeg.exe", "-i", input_path, output_path, "-y"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def transcribe_audio(path):
    model = whisper.load_model("base")  
    result = model.transcribe(path, language="fr")
    return result["text"]

# ======== Fichier à analyser ========
file = "documents/audio2.mp3"  # Remplacez par le chemin de votre fichier audio ou image

# ======== Traitement du fichier ========
if file.endswith(".mp3"):
    wav_path = "temp_audio.wav"
    convert_mp3_to_wav(file, wav_path)
    raw_text = transcribe_audio(wav_path)
elif file.endswith(".pdf"):
    raw_text = ocr_pdf(file)
else:
    raw_text = ocr_image(file)

print("Texte détecté :\n", raw_text)

cleaned_text = clean_text(raw_text)

keywords = extract_keywords_yake(cleaned_text, top_n=15)
filtered_keywords = filter_keywords(keywords)

print("\nMots-clés suggérés après filtrage :")
for kw, score in filtered_keywords:
    print(f"- {kw} (score : {score:.4f})")
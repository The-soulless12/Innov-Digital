import os
import pytesseract
from PIL import Image

# Clear any old TESSDATA_PREFIX settings
if "TESSDATA_PREFIX" in os.environ:
    del os.environ["TESSDATA_PREFIX"]

# Set it explicitly for the current script execution


pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# Perform OCR
text = pytesseract.image_to_string(Image.open("temp_page.png"), lang="fra")
print(text)
#!/usr/bin/env python3
import sys
import json
import cv2
import pytesseract
from PIL import Image
import numpy as np
import os

def extract_text_from_image(image_path):
    try:
        # Verify file exists
        if not os.path.exists(image_path):
            return {
                "success": False,
                "error": f"Image file not found: {image_path}",
                "extracted_text": ""
            }
        
        # Load image with PIL first (more reliable)
        pil_image = Image.open(image_path)
        
        # Convert PIL to OpenCV format
        opencv_image = cv2.cvtColor(np.array(pil_image), cv2.COLOR_RGB2BGR)
        
        # Preprocessing for better OCR
        gray = cv2.cvtColor(opencv_image, cv2.COLOR_BGR2GRAY)
        
        # Apply threshold
        _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        
        # Extract text using Tesseract with specific config for t-shirts
        custom_config = r'--oem 3 --psm 6 -c tessedit_char_whitelist=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,!?-'
        text = pytesseract.image_to_string(thresh, config=custom_config)
        
        # Clean up extracted text
        cleaned_text = ' '.join(text.split()).strip()
        
        return {
            "success": True,
            "extracted_text": cleaned_text,
            "confidence": "high" if len(cleaned_text) > 0 else "low",
            "image_path": image_path
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "extracted_text": "",
            "image_path": image_path
        }

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(json.dumps({"success": False, "error": "Usage: python3 snuggig_ocr.py <image_path>"}))
        sys.exit(1)
    
    result = extract_text_from_image(sys.argv[1])
    print(json.dumps(result))

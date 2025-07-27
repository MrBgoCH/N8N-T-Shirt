FROM n8nio/n8n:latest

# Switch to root to install system packages
USER root

# Install Tesseract OCR and dependencies (Alpine Linux packages)
RUN apk add --no-cache \
    tesseract-ocr \
    tesseract-ocr-data-eng \
    python3 \
    py3-pip \
    gcc \
    g++ \
    musl-dev \
    python3-dev \
    jpeg-dev \
    zlib-dev \
    freetype-dev \
    lcms2-dev \
    openjpeg-dev \
    tiff-dev \
    tk-dev \
    tcl-dev \
    harfbuzz-dev \
    fribidi-dev \
    libimagequant-dev \
    libxcb-dev \
    libpng-dev

# Install Python packages
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Create scripts directory and copy OCR script
RUN mkdir -p /home/node/scripts
COPY scripts/snuggig_ocr.py /home/node/scripts/
RUN chmod +x /home/node/scripts/snuggig_ocr.py

# Create upload directory
RUN mkdir -p /tmp/n8n-uploads && chmod 777 /tmp/n8n-uploads

# Switch back to node user
USER node

# Set environment variables
ENV N8N_USER_FOLDER=/home/node/.n8n
ENV WORKFLOWS_FOLDER=/home/node/.n8n/workflows

EXPOSE 5678

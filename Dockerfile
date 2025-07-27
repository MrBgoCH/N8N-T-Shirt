FROM n8nio/n8n:latest

# Switch to root to install system packages
USER root

# Install Tesseract OCR and dependencies
RUN apt-get update && \
    apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    python3-pip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

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

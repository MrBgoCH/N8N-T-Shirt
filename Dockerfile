# Use Ubuntu base for better package support
FROM ubuntu:22.04

# Install Node.js, npm, Python, and Tesseract
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    python3 \
    python3-pip \
    tesseract-ocr \
    tesseract-ocr-eng \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install n8n globally
RUN npm install -g n8n

# Create node user
RUN useradd -m -s /bin/bash node

# Install Python packages with pre-built wheels
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Create directories and copy files
RUN mkdir -p /home/node/scripts /tmp/n8n-uploads
COPY scripts/snuggig_ocr.py /home/node/scripts/
RUN chmod +x /home/node/scripts/snuggig_ocr.py
RUN chmod 777 /tmp/n8n-uploads

# Set ownership
RUN chown -R node:node /home/node

# Switch to node user
USER node

# Set environment variables
ENV N8N_USER_FOLDER=/home/node/.n8n
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678

WORKDIR /home/node

EXPOSE 5678

CMD ["n8n", "start"]

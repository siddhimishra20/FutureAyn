FROM n8nio/n8n:latest

USER root

# Install system dependencies and build tools
RUN apk add --no-cache python3 py3-pip build-base libffi-dev openssl-dev musl-dev cargo

# Upgrade pip, setuptools, wheel
RUN python3 -m pip install --upgrade --break-system-packages pip setuptools wheel


USER node

# Install Python packages locally for node user with break-system-packages flag
RUN python3 -m pip install --user --break-system-packages \
    feedparser \
    requests \
    beautifulsoup4 \
    tldextract \
    fake-useragent 

# Add local bin and site-packages to PATH and PYTHONPATH
ENV PATH="/home/node/.local/bin:$PATH"
ENV PYTHONPATH="/home/node/.local/lib/python3.12/site-packages"



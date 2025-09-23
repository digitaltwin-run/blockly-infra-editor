FROM python:3.11-slim

WORKDIR /app

# Set non-interactive frontend and use a reliable mirror
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Copy only requirements first for better layer caching
COPY requirements.txt .

# Install runtime dependencies using pre-built wheels
RUN pip install --no-cache-dir --only-binary=:all: -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose the default port
EXPOSE 8083

# Set environment variables
ENV FLASK_APP=blockly-editor.py
ENV FLASK_ENV=production

# Run the application
CMD ["python", "blockly-editor.py", "--no-browser"]

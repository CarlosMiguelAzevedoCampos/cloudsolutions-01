# Use the official lightweight Python image
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies (optional but safer for boto3, ssl)
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /opt/cloudsolutions-app

# Copy dependency list first
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app code
COPY app.py .

# Make sure log directory exists
RUN mkdir -p /var/log

# Expose port 80
EXPOSE 80

# Command to run the app
CMD ["python", "app.py"]

FROM python:3.7-slim-buster

WORKDIR /app

# Create pip configuration
RUN echo "[global]" > /etc/pip.conf && \
    echo "timeout = 100" >> /etc/pip.conf && \
    echo "retries = 3" >> /etc/pip.conf

# Install system dependencies first
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first
COPY requirements.txt .

# Install packages with increased timeout
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir numpy==1.21.6 && \
    pip install --no-cache-dir pandas==1.3.5 && \
    pip install --no-cache-dir scikit-learn==0.24.2 && \
    pip install --no-cache-dir Flask==2.0.3 && \
    pip install --no-cache-dir matplotlib==3.5.3 && \
    pip install --no-cache-dir seaborn==0.12.2 && \
    pip install --no-cache-dir dill==0.3.6 && \
    pip install --no-cache-dir xgboost==1.5.0 && \
    pip install --no-cache-dir catboost==1.0.6

# Copy the rest of the application
COPY . .

CMD ["python3", "app.py"]
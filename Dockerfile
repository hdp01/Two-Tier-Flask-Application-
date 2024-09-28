# Base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory inside the container
WORKDIR /app

# Copy the requirements.txt to the container
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire Flask app to the container
COPY . /app/

# Expose the port the Flask app runs on
EXPOSE 80

# Health check to ensure the app is running
HEALTHCHECK CMD curl --fail http://localhost:443/ || exit 1

# Command to run the Flask app
CMD ["python", "app.py"]

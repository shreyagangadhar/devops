FROM python:3.8-slim

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=80

# Use a secure method to set the database URL (this should be passed at runtime)


# Expose the port Flask will run on
EXPOSE 80

# Set the working directory
WORKDIR /app

# Copy only requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Run the Flask application
RUN flask db upgrade
CMD ["flask", "run"]
FROM python:3.8-slim

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8001

# Use a secure method to set the database URL (this should be passed at runtime)
ENV DATABASE_URL='postgresql://postgres:nqx2N6|to9amD{WH#oxIykx]E<V!@app-db.cfxqggmg32rx.us-west-2.rds.amazonaws.com:5432/postgres'

# Expose the port Flask will run on
EXPOSE 8001

# Set the working directory
WORKDIR /app

# Copy only requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Run the Flask application
CMD ["flask", "run"]

#!/bin/bash

# Read the secret file and export it
export DATABASE_URL_FILE=$(cat /run/secrets/db_url)

# Run database migrations
flask db upgrade

# Start the Flask application
exec flask run
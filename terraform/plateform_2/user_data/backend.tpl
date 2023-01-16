#!/bin/bash

# Update the package manager
sudo apt-get update

# Install Python and pip
sudo apt-get install -y python3-pip

# Install git
sudo yum install -y git

# Clone the react application from Github
git clone https://github.com/EpiTobby/DuckAPI.git

# Move to the frontend folder
cd DuckAPI/duckapi

# Create a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install FastAPI and its dependencies
pip install fastapi uvicorn

export MONGO_URL=${mongo_url}

# Start the server
uvicorn app:app --host 0.0.0.0 --port 3000

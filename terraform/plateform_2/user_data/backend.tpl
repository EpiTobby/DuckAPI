#!/bin/bash

# Update the package manager
sudo yum update -y

#Download get-pip to current directory. It won't install anything, as of now
curl -O https://bootstrap.pypa.io/get-pip.py

#Use python3.6 to install pip
python3 get-pip.py

# Install git
sudo yum install -y git

# Clone the react application from Github
git clone https://github.com/EpiTobby/DuckAPI.git

# Move to the frontend folder
cd DuckAPI/

pip3 install fastapi uvicorn pymongo sqlalchemy

export MONGO_HOST=${mongo_url}

echo "MONGO_HOST=${mongo_url}" > .env

# Start the server
uvicorn duckapi.app:app --host 0.0.0.0

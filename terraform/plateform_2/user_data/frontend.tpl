#!/bin/bash
sudo su

# Update the package manager
yum update -y

yum install -y httpd.x86_64
yum install -y jq

REGION_AV_ZONE=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .availabilityZone -r`

systemctl start httpd.service
systemctl enable httpd.service

echo “Hello World from $(hostname -f) from the availability zone: $REGION_AV_ZONE ${api_url}” > /var/www/html/index.html

# Install Node.js and npm
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
yum install -y nodejs

# Install git
yum install -y git

# Clone the react application from Github
git clone https://github.com/EpiTobby/DuckAPI.git

# Move to the frontend folder
cd DuckAPI/duckfront

# Install the dependencies
npm install

export REACT_APP_API_URL=${api_url}

echo "REACT_APP_API_URL=${api_url}" > .env

# Build the application
npm run build

npm install -g serve

serve -s build -l 3000
#!/bin/bash
echo "Installing MongoDB"
# commands to install and run MongoDB, including setting up read replica

# Update the package manager
sudo yum update

sudo yum install -y mongodb-org

sudo systemctl start mongod

sudo systemctl enable mongod
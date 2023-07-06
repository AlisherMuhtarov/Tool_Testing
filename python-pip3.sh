#!/bin/bash

# Update system packages
sudo yum update -y

# Install required dependencies
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel

# Download Python 3.9.17 source code
wget https://www.python.org/ftp/python/3.9.17/Python-3.9.17.tgz

# Extract the source code
tar -xf Python-3.9.17.tgz

# Change to the extracted directory
cd Python-3.9.17

# Configure the Python build
./configure --enable-optimizations

# Compile and install Python
sudo make altinstall

# Verify Python installation
python3.9 --version

# Install pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.9 get-pip.py

# Verify pip installation
pip3.9 --version

# Clean up
cd ..
rm -rf Python-3.9.17 Python-3.9.17.tgz get-pip.py

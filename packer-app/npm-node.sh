#!/bin/bash

# Remove existing npm installation
sudo yum remove -y npm

# Download and install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Load nvm script into the current shell session
source ~/.bashrc

# Install Node.js version 18.14.0 using nvm
nvm install 18.14.0

# Set Node.js version 18.14.0 as the active version
nvm use 18.14.0

# Create a symbolic link for the node binary
ln -s /root/.nvm/versions/node/v18.14.0/bin/node /usr/local/bin/node

# Add the export PATH line to the last line of .bashrc in ec2-user directory
echo 'export PATH="/root/.nvm/versions/node/v18.14.0/bin:$PATH"' >> /home/ec2-user/.bashrc

# Install npm version 8.6.0 globally using the newly installed Node.js
npm install -g npm@8.6.0

# Display the installed Node.js and npm versions
node --version
npm --version

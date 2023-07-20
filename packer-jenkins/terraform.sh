#!/bin/bash

# Install yum-utils, a collection of utilities that extend and supplement the functionality of yum package manager.
sudo yum install -y yum-utils

# Add HashiCorp repository to yum configuration, so that yum can find and install Terraform.
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform using yum package manager.
sudo yum -y install terraform

# Verify Terraform installation by displaying its version.
terraform --version

# Download the Jenkins repository configuration
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins package signing key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade packages to their latest versions
sudo yum upgrade

# Add required dependencies for the Jenkins package (Java 11 Amazon Corretto)
sudo dnf install java-11-amazon-corretto -y

# Install Jenkins using yum package manager
sudo yum install jenkins

# Reload systemd to recognize the Jenkins service
sudo systemctl daemon-reload

sudo systemctl enable jenkins

sudo systemctl start jenkins

sudo systemctl status jenkins

# Install Git
sudo yum install git -y

# Install yum-utils again (already installed earlier, seems duplicated)
sudo yum install -y yum-utils

# Install Packer
sudo yum -y install packer

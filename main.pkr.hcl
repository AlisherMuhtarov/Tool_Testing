packer {
  required_version = "<=1.9.1"
  required_plugins {
    amazon = {
      version = ">= 1.2.5"
      source = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "amazonlinux" {
  filters = {
      virtualization-type = "hvm"
      name = "base-image"
      root-device-type = "ebs"
  }

  owners = ["555519622762"]
  most_recent = true
  region = "us-east-1"
}

source "amazon-ebs" "launching" {

  ami_name             = "ami_requirements{{timestamp}}"
  instance_type        = "t2.micro"
  region               = "us-east-1"
  source_ami           = data.amazon-ami.amazonlinux.id
  ssh_username         = "ec2-user"
  communicator         = "ssh"

  force_deregister = false

}


build {
  sources = ["source.amazon-ebs.launching"]

  provisioner "file" {
    source = "python&pip3.sh"
    destination = "/tmp/python&pip3.sh"
  }

  provisioner "file" {
    source = "requirements.txt"
    destination = "/tmp/requirements.txt"
  }

  provisioner "file" {
    source = "npm&node.sh"
    destination = "/tmp/npm&node.sh"
  }

  provisioner "shell" {

    inline = [
      "pip3 install -r /tmp/requirements.txt",
      "chmod +x /tmp/python&pip3.sh",
      "chmod +x /tmp/npm&node.sh",
      "/tmp/python&pip3.sh",
      "/tmp/npm&node.sh",
    ]
  }
}

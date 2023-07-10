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
    source = "terraform.sh"
    destination = "/home/ec2-user/terraform.sh"
  }

  provisioner "file" {
    source = "python-pip3.sh"
    destination = "/home/ec2-user/python-pip3.sh"
  }

  provisioner "file" {
    source = "requirements.txt"
    destination = "/home/ec2-user/requirements.txt"
  }

  provisioner "file" {
    source = "npm-node.sh"
    destination = "/home/ec2-user/npm-node.sh"
  }

  provisioner "file" {
    source = "sqlite3.sh"
    destination = "/home/ec2-user/sqlite.sh"
  }

  provisioner "file" {
    source = "/home/ec2-user/python-pycone"
    destination = "/home/ec2-user/python-pycone"
  }

  provisioner "shell" {

    inline = [
      "sudo yum install git -y",
      "sudo chmod +x /home/ec2-user/terraform.sh",
      "sudo bash /home/ec2-user/terraform.sh"
      "sudo chmod +x /home/ec2-user/python-pip3.sh",
      "sudo bash /home/ec2-user/python-pip3.sh",
      "sudo pip3 install -r /home/ec2-user/requirements.txt",
      "sudo bash /home/ec2-user/sqlite.sh",
      "sudo sudo chmod +x /home/ec2-user/npm-node.sh",
      "sudo bash /home/ec2-user/npm-node.sh",
      "cd /home/ec2-user/python-pycone"
    ]
  }
}

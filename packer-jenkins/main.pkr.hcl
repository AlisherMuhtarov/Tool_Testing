packer {
  required_version = "<=1.9.1"
  required_plugins {
    amazon = {
      version = ">= 1.2.5"
      source = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  aws_account_id = file("/tmp/aws_account_id.txt")
}

data "amazon-ami" "amazonlinux" {
  filters = {
      virtualization-type = "hvm"
      name = "base-image"
      root-device-type = "ebs"
  }

  owners = [local.aws_account_id] 
  most_recent = true
  region = "us-east-1"
}

source "amazon-ebs" "launching" {

  ami_name             = "jenkins_ami_requirementsv2{{timestamp}}"
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
    source = "jenkinsinit.sh"
    destination = "/home/ec2-user/jenkinsinit.sh"
  }

  provisioner "shell-local" {
    inline = ["export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query \"Account\" --output text) && echo $AWS_ACCOUNT_ID > /tmp/aws_account_id.txt"]
  }

  provisioner "shell" {

    inline = [
      "sudo chmod +x /home/ec2-user/terraform.sh /home/ec2-user/python-pip3.sh /home/ec2-user/jenkinsinit.sh",
      "sudo bash /home/ec2-user/terraform.sh",
      "sudo bash /home/ec2-user/python-pip3.sh",
      "sudo bash /home/ec2-user/jenkinsinit.sh"
    ]
  }
}

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

  owners = [""] 
  most_recent = true
  region = "us-east-1"
}

source "amazon-ebs" "launching" {

  ami_name             = "jenkins_ami_requirements{{timestamp}}"
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

  provisioner "shell" {

    inline = [
      "sudo chmod +x /home/ec2-user/terraform.sh /home/ec2-user/python-pip3.sh",
      "sudo bash /home/ec2-user/terraform.sh",
      "sudo bash /home/ec2-user/python-pip3.sh",
      "cd /home/ec2-user/python-pycone",
    ]
  }
}

packer {
  required_version = "<=1.9.1"
  required_plugins {
    amazon = {
      version = ">= 1.2.5"
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  default = env("ID")
}

data "amazon-ami" "amazonlinux" {
  filters = {
      virtualization-type = "hvm"
      name = "base-image"
      root-device-type = "ebs"
  }

  owners = ["${var.aws_region}"]
  most_recent = true
  region = "us-east-1"
}

source "amazon-ebs" "launching" {

  ami_name             = "jenkins_ami_requirements.v3{{timestamp}}"
  instance_type        = "t2.micro"
  iam_instance_profile = "Terraform-Server-Role"
  region               = "us-east-1"
  security_group_ids   = ["sg-0ba543c6b5678587a"]
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

  provisioner "file" {
    source = "jenkinsinit.sh"
    destination = "/home/ec2-user/installing-jenkins-plugins.sh"
  }

  provisioner "shell" {

    inline = [
      "export ip=$(aws ec2 describe-instances --instance-ids i-01b1d1cb86b761087 --query 'Reservations[0].Instances[0].PublicDnsName' --output text)",
      "echo $ip",
      "sudo chmod +x /home/ec2-user/terraform.sh /home/ec2-user/python-pip3.sh /home/ec2-user/jenkinsinit.sh /home/ec2-user/installing-jenkins-plugins.sh",
      "sudo bash /home/ec2-user/terraform.sh",
      "sudo bash /home/ec2-user/python-pip3.sh",
      "sudo bash /home/ec2-user/jenkinsinit.sh",
      "sudo bash /home/ec2-user/installing-jenkins-plugins.sh"
    ]
  }
}

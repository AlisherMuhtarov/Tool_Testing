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

  ami_name             = "hoodcustomizations-source-ami"
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

  provisioner "file" {
    source = "AK.service"
    destination = "/home/ec2-user/AK.service"
  }

  provisioner "shell" {

    inline = [
      "sudo mkdir -p /var/log/myapp",
      "sudo touch /var/log/myapp/output.log && sudo touch /var/log/myapp/error.log",
      "sudo yum install git -y",
      "sudo mv /home/ec2-user/AK.service /etc/systemd/system/",
      "sudo chmod +x /home/ec2-user/terraform.sh /home/ec2-user/python-pip3.sh /home/ec2-user/npm-node.sh /home/ec2-user/sqlite.sh",
      "sudo bash /home/ec2-user/terraform.sh",
      "sudo bash /home/ec2-user/python-pip3.sh && sudo pip3 install -r /home/ec2-user/requirements.txt",
      "sudo bash /home/ec2-user/sqlite.sh",
      "sudo bash /home/ec2-user/npm-node.sh",
      "cd /home/ec2-user/python-pycone",
      "sudo chown root:root /etc/systemd/system/AK.service && sudo chown root:root /var/log/myapp/output.log && sudo chown root:root /var/log/myapp/error.log",
      "sudo chmod 644 /etc/systemd/system/AK.service",
      "sudo systemctl daemon-reload && sudo systemctl start AK && sudo systemctl enable AK && sudo systemctl restart AK"
    ]
  }
}

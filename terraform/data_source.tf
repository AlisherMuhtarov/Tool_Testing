data "aws_ami" "ec2_launch" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["ami_requirements*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ip_ranges" "current" {
  regions = ["us-east-1"]
  services = ["amazon"]
}

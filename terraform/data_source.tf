data "aws_ami" "ec2_launch" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ami_requirements1689288088"]
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

data "aws_route53_zone" "app" {
  name         = "virmzi.de"
  private_zone = false
}

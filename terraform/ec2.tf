resource "aws_instance" "first_ec2" {
  ami                    = data.aws_ami.ec2_launch.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [ aws_security_group.main_sg.id ]
  tags = {
    Name = var.env
  }
}

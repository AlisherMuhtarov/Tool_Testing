resource "aws_security_group" "ec2_sg" {
  name        = "main"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = var.ports[5]
    to_port     = var.ports[5]
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[1]]
  }

  ingress {
    from_port   = var.ports[3]
    to_port     = var.ports[3]
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[1]]
  }

  ingress {
    from_port   = var.ports[4]
    to_port     = var.ports[4]
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[1]]
  }

  egress {
    from_port   = var.ports[0]
    to_port     = var.ports[0]
    protocol    = var.protocol[0]
    security_groups = [aws_security_group.lb_sg.id]
    cidr_blocks = [var.cidrs[0]]
  }

}

resource "aws_security_group" "lb_sg" {
  name        = "main"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = var.ports[4]
    to_port     = var.ports[4]
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[1]]
  }

  egress {
    from_port   = var.ports[0]
    to_port     = var.ports[0]
    protocol    = var.protocol[0]
    security_groups = [aws_security_group.ec2_sg.id]
    cidr_blocks = [var.cidrs[0]]
  }

}


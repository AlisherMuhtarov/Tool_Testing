resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
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
    cidr_blocks = [var.cidrs[0]]
  }

  egress {
    from_port   = var.ports[0]
    to_port     = var.ports[0]
    protocol    = var.protocol[0]
    cidr_blocks = [var.cidrs[0]]
  }

}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = var.ports[4]
    to_port     = var.ports[4]
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[0]]
  }

  ingress {
    from_port   = var.ports[3]
    to_port     = var.ports[3]
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[0]]
  }

  egress {
    from_port   = var.ports[0]
    to_port     = var.ports[0]
    protocol    = var.protocol[0]
    cidr_blocks = [var.cidrs[0]]
  }

}

resource "aws_security_group_rule" "ec2_to_alb" {
  type              = "ingress"
  from_port         = var.ports[5]
  to_port           = var.ports[5]
  protocol          = var.protocol[1]
  cidr_blocks       = [var.cidrs[1]]
  source_security_group_id = aws_security_group.lb_sg.id
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_to_alb-2" {
  type              = "ingress"
  from_port         = var.ports[4]
  to_port           = var.ports[4]
  protocol          = var.protocol[1]
  cidr_blocks       = [var.cidrs[1]]
  source_security_group_id = aws_security_group.lb_sg.id
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "alb_to_ec2" {
    type = "ingress"
    from_port   = var.ports[5]
    to_port     = var.ports[5]
    source_security_group_id = aws_security_group.ec2_sg.id
    security_group_id = aws_security_group.lb_sg.id
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[1]]
  }

resource "aws_security_group_rule" "alb_to_ec2-2" {
    type = "ingress"
    from_port   = var.ports[3]
    to_port     = var.ports[3]
    source_security_group_id = aws_security_group.ec2_sg.id
    security_group_id = aws_security_group.lb_sg.id
    protocol    = var.protocol[1]
    cidr_blocks = [var.cidrs[0]]
}
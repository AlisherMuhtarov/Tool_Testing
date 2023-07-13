resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH inbound traffic"
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow SSH inbound traffic"
}

resource "aws_security_group_rule" "ec2_to_lb" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  from_port         = var.ports[5]
  to_port           = var.ports[5]
  protocol          = var.protocol[1]
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "ec2_to_lb" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  from_port         = var.ports[5]
  to_port           = var.ports[5]
  protocol          = var.protocol[0]
}

resource "aws_security_group_rule" "ec2_to_lb" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  from_port         = var.ports[4]
  to_port           = var.ports[4]
  protocol          = var.protocol[0]
}

resource "aws_security_group_rule" "ec2_to_lb" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  from_port         = var.ports[3]
  to_port           = var.ports[3]
  protocol          = var.protocol[0]
}


resource "aws_security_group_rule" "lb_to_ec2" {
  security_group_id = aws_security_group.lb_sg.id
  type              = "ingress"
  from_port         = var.ports[5]
  to_port           = var.ports[5]
  protocol          = var.protocol[1]
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "lb_to_ec2" {
  security_group_id = aws_security_group.lb_sg.id
  type              = "ingress"
  from_port         = var.ports[3]
  to_port           = var.ports[3]
  protocol          = var.protocol[1]
  source_security_group_id = aws_security_group.ec2_sg.id
}


resource "aws_security_group_rule" "allow_ssh_ec2" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  from_port         = var.ports[3]
  to_port           = var.ports[3]
  protocol          = var.protocol[1]
  cidr_blocks       = [var.cidrs[0]]
}

resource "aws_security_group_rule" "allow_http_lb" {
  security_group_id = aws_security_group.lb_sg.id
  type              = "ingress"
  from_port         = var.ports[4]
  to_port           = var.ports[4]
  protocol          = var.protocol[1]
  cidr_blocks       = [var.cidrs[0]]
}

resource "aws_security_group_rule" "allow_https_lb" {
  security_group_id = aws_security_group.lb_sg.id
  type              = "ingress"
  from_port         = var.ports[3]
  to_port           = var.ports[3]
  protocol          = var.protocol[1]
  cidr_blocks       = [var.cidrs[0]]
}

resource "aws_security_group_rule" "allow_outbound" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "egress"
  from_port         = var.ports[0]
  to_port           = var.ports[0]
  protocol          = var.protocol[0]
  cidr_blocks       = [var.cidrs[0]]
}

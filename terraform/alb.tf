resource "aws_lb" "app" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_sg.id]
  subnets            = ["subnet-098ab2c379f487d8e", "subnet-00c67e8302ea518f9", "subnet-01b15e0262af666eb", "subnet-0b0a23f9960c0f286", "subnet-0995c7e89a01454d4", "subnet-0eebce24507f2bbb6"]

  ip_address_type = "ipv4"
  enable_deletion_protection = false

  access_logs {
    bucket = "elb-access-log-terraform-dump"
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"  # Specify the SSL policy to use
  certificate_arn = aws_acm_certificate.app.arn   # Use the ARN of the ACM certificate
}
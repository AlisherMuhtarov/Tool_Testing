resource "aws_lb_target_group" "app" {
  name     = "elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0c5d61951cc331de6"
}
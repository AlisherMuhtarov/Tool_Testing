resource "aws_lb_target_group" "app" {
  name     = "elb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-0c5d61951cc331de6"

    health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTPS"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }
}
resource "aws_autoscaling_group" "app" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.app_asg_lc.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      // You probably want more than 50% healthy depending on how much headroom you have
      min_healthy_percentage = 50
    }
    // Depending the triggers you wish to configure, you may not want to include this
    triggers = ["tag"]

    lifecycle {
      create_before_destroy = true
    }
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app.name
  lb_target_group_arn    = aws_lb_target_group.app.arn
}

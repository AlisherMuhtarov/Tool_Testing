resource "aws_launch_template" "app_asg_lc" {
  name = "APP_ASG_LC"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  key_name = "laptop_key"

  instance_type = "t2.medium"

  image_id = data.aws_ami.ec2_launch.id

  instance_initiated_shutdown_behavior = "stop"

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-east-1a"
  }

  vpc_security_group_ids = [ aws_security_group.main_sg.id ]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "App"
    }
  }

}
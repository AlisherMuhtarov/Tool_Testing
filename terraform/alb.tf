resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_sg.id]
  subnets            = ["subnet-098ab2c379f487d8e", "subnet-00c67e8302ea518f9", "subnet-01b15e0262af666eb"]
  
  ip_address_type = "ipv4"
  enable_deletion_protection = true

  access_logs {
    bucket = "elb-access-log-terraform-dump"
  }

  tags = {
    Environment = "production"
  }
}
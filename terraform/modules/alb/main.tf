module "vpc" {
  source = "../vpc"
}

resource "aws_lb" "alb" {
  name = "alb"
  internal = true
  load_balancer_type = "application"
  security_groups = ["aws_security_group.sg.id"]
  subnets = "aws_subnet.private.id"

  enable_deletion_protection = false

  tags = {
    Name = "alb"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "tg" {
  name = "tg"
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
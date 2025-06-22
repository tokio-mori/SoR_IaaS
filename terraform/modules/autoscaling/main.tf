resource "aws_autoscaling_group" "asg" {
  name = "dev-autoscaling"
  vpc_zone_identifier = ["aws_subnet.private.id"]
  target_group_arns = ["hoge"]
  health_check_type = "ELB"
  health_check_grace_period = 300

  min_size = 2
  max_size = 6
  desired_capacity = 2

  launch_template {
    id = aws_launch_template.hoge
    version = "$Latest"
  }

  tag {
    key = "Environment"
    value = "asg-value"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "dev-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "dev-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

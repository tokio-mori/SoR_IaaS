resource "aws_launch_template" "main" {
  name = "template"
  image_id = ami.id
  instance_type = "var.instance_type"
  key_name = "var.key_name"

  vpc_security_group_ids = [ aws_securiy_group.id ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "hoge-asg-instance"
      Environment = "var.environment"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "hog-launch-template"
    Environment = "var.environment"
  }
  user_data = filebase64("${path.module}/example.sh")

}
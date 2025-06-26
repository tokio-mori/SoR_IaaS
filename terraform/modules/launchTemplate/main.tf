data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-x86_64-gp2" ]
  }
}

resource "aws_launch_template" "main" {
  name = "template"
  image_id = data.aws_ami.amazon_linux.id 
  instance_type = "var.instance_type"
  key_name = "var.key_name"

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    name = var.iam_instance_profile
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
  user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y
                EOF
              )
}
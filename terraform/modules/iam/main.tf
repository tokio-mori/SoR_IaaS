resource "aws_iam_instance_profile" "main" {
  name = "profile"
  role = aws_iam_role.main.name
}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "main" {
  name               = "role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.main.json
}
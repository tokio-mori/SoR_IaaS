output "security_group_id" {
  value = aws_security_group.sg.id
}

output "aws_subnet_private_id" {
  value = aws_subnet.private.id
}

output "aws_vpc_id" {
  value = aws_vpc.main.id
}
resource "aws_instance" "ec2" {
  count = 2
  
  ami = "ami-02457590d33d576c3"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["aws_security_group.sg.id"]
  subnet_id = "aws_subnet.private.id"

  tags = {
    Name = "Test_EC2"
  }
}
resource "aws_db_subnet_group" "subnet" {
  name = "main"
  subnet_ids = [aws_subnet.private.id]

  tags = {
    Name = "private subnet group"
  }
}

data "aws_rds_orderable_db_instance" "orderable" {
  engine = "mysql"
  engine_version = "8.0.41"
  storage_type = "standard"
  preferred_instance_classes = ["db.m7g.large"]
}

resource "aws_db_option_group" "option" {
  name = "option-group-terraform"
  engine_name = "mysqlserver"
  major_engine_version = "8.0.41"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

data "aws_kms_key" "kms" {
  key_id = "hoge"
}

resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql5.6"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "instance" {
  allocated_storage = 10
  max_allocated_storage = 100
  auto_minor_version_upgrade = false
  //custom_iam_instance_profile = hoge
  backup_retention_period = 7
  engine = hoge
  engine_version = hoge
  identifier = "app"
  instance_class = hoge
  kms_key_id = hoge
  multi_az = true
  password = hoge
  username = "admin"
  storage_encrypted = true
  backup_window = "09:10-09:40"
  maintenance_window = "mon:10:10-mon:10:40"
  vpc_security_group_ids = hoge
  parameter_group_name = hoge
  option_group_name = hoge
  db_subnet_group_name = hoge

  lifecycle {
    ignore_changes = [ password ]
  }
}
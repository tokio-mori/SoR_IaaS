module "kms" {
  source = "../kms/kmsRds"
}
module "vpc" {
  source = "../vpc"
}

resource "aws_db_subnet_group" "subnet" {
  name = "main"
  subnet_ids = ["../vpc/main.tf/aws_subnet.private.id"]

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
  backup_retention_period = 7
  engine = "mysql"
  engine_version = "8.0.41"
  identifier = "app"
  instance_class = "db.m5d.large"
  kms_key_id = module.kms.aliasrds_arn
  multi_az = true
  password = "TestPassword"
  username = "admin"
  storage_encrypted = true
  backup_window = "09:10-09:40"
  maintenance_window = "mon:10:10-mon:10:40"
  vpc_security_group_ids = [module.vpc.security_group_id]
  parameter_group_name = aws_db_parameter_group.default.name
  option_group_name = aws_db_option_group.option.name
  db_subnet_group_name = aws_db_subnet_group.subnet.name

  lifecycle {
    ignore_changes = [ password ]
  }
}
module "vpc" {
  source = "../../modules/vpc"
}

module "ec2" {
  source = "../../modules/ec2"
}

module "iam" {
  source = "../../modules/iam"
}

module "launch_tempalate" {
  source = "../../modules/launchTemplate"

  security_group_ids = [module.vpc.security_group_id]
  iam_instance_profile = module.iam.iam_instance_profile
}

module "auto_scaling" {
  source = "../../modules/autoscaling"

  launch_template_id = module.launch_tempalate.launch_template_id
}

module "redis_sg" {
  source = "../../modules/elasticache"
}

module "rds" {
  source = "../../modules/rds"  
}

module "alb" {
  source = "../../modules/alb"

  subnet_private_id = module.vpc.aws_subnet_private_id
  aws_vpc_id = module.vpc.aws_vpc_id
}

module "name" {
  source = "../../modules/apiGateway"

  aws_lb_alb = module.alb.aws_lb_alb
  alb_dns_name = module.alb.alb_dns_name
}
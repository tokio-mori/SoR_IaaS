module "vpc" {
  source = "../../modules/vpc"
}

module "ec2" {
  source = "../../modules/ec2"
}

module "redis_sg" {
  source = "../../modules/elasticache"
}

module "rds" {
  source = "../../modules/rds"  
}
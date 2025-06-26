module "vpc" {
  source = "../../modules/vpc"
}

module "ec2" {
  source = "../../modules/ec2"
}

module "launch_tempalte" {
  source = "../../modules/launchTemplate"
}

module "auto_scaling" {
  source = "../../modules/autoscaling"

  launch_template_id = module.launch_tempalte.main.id
}

# module "redis_sg" {
#   source = "../../modules/elasticache"
# }

# module "rds" {
#   source = "../../modules/rds"  
# }



/*---------------------------------------
宣言しなくても内部呼び出しされているリスト
-----------------------------------------*/
module "security_group" {
  source = "../../modules/securityGroup"
}
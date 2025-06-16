resource "aws_elasticache_parameter_group" "elasticache" {
  name = "cache-params"
  family = "redis7.22.0"

 parameter {
  name = "cluster-enabled"
  value = "no"
 } 
}

resource "aws_elasticache_subnet_group" "subnet" {
  name = "elasticache-subnet"
  subnet_ids = ["../vpc/main.tf/aws_subnet.private.id"]
}

resource "aws_elasticache_replication_group" "replication" {
  replication_group_id = "primary"
  description = "elasticache to primary"
  engine = "redis"
  engine_version = "7.22"
  num_cache_clusters = 2
  node_type = "cache.t3.medium"
  snapshot_window = "09:10-10:10"
  snapshot_retention_limit = 7
  maintenance_window = "mon:10:40-mon:11:40"
  automatic_failover_enabled = true
  port = 6379
  security_group_ids = [  ]
  parameter_group_name = aws_elasticache_parameter_group.elasticache.name
  subnet_group_name = aws_elasticache_subnet_group.subnet.name
}
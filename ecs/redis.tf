resource "aws_elasticache_subnet_group" "this" {
  name       = "boutique-cache-subnet"
  subnet_ids = [var.private_subnet1_id]
}

resource "aws_elasticache_replication_group" "this" {
  automatic_failover_enabled  = false
  replication_group_id        = "boutique-rep-group-1"
  description                 = "boutique"
  node_type                   = "cache.t3.micro"
  num_cache_clusters          = 1
  parameter_group_name        = "default.redis3.2"
  port                        = 6379
  apply_immediately           = true
  engine                      = "redis"
  #engine_version              = "7.0.7"
  security_group_ids          = [aws_security_group.redis.id]
  snapshot_retention_limit    = "0"
  subnet_group_name           = aws_elasticache_subnet_group.this.name
}


resource "aws_security_group" "redis" {
  description = "sg for redis"
  name        = "redis_sg"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "redis_egress_any" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "egress any/any"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.redis.id
  to_port           = -1
  type              = "egress"
}

resource "aws_security_group_rule" "redis_itself_any" {
  description       = "itself"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.redis.id
  self              = true
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "redis_ingress_ecs_tcp_redis" {
  description       = "ingress TCP/6379"
  from_port         = 6379
  protocol          = "tcp"
  security_group_id = aws_security_group.redis.id
  source_security_group_id = "sg-01d1755e60e9fd5ad"
  to_port           = 6379
  type              = "ingress"
}
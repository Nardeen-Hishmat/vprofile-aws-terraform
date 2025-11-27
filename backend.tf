# 1. RDS (MySQL)
resource "aws_db_instance" "vprofile-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  
  # تصحيح الخطأ القديم: الاسم لازم يكون accounts زي كود الجافا
  db_name                = "accounts"
  
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.vprofile-backend-sg.id]
}

# 2. ElastiCache (Memcached)
resource "aws_elasticache_cluster" "vprofile-cache" {
  cluster_id           = "vprofile-cache"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  security_group_ids   = [aws_security_group.vprofile-backend-sg.id]
}

# 3. Amazon MQ (RabbitMQ)
resource "aws_mq_broker" "vprofile-rmq" {
  broker_name        = "vprofile-rmq"
  engine_type        = "RabbitMQ"
  engine_version     = "3.13"
  host_instance_type = "mq.t3.micro"
  security_groups    = [aws_security_group.vprofile-backend-sg.id]
  publicly_accessible = false 
  
  # تصحيح الخطأ القديم: السطر ده إجباري في النسخ الجديدة
  auto_minor_version_upgrade = true

  user {
    username = var.rmq_username
    password = var.rmq_password
  }
}
resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "primary" {
  identifier          = "stb-my-db-instance"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  skip_final_snapshot           = true
  multi_az            = var.create_replica ? true : false  # Configura Multi-AZ según si hay réplica
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  username            = var.db_username
  password            = var.db_password
}

resource "aws_db_instance" "replica" {
  count                          = var.create_replica ? var.rds_replicas : 0  # Solo crea la réplica si create_replica es true
  identifier                     = "stb-my-db-replica-${count.index}"
  engine                         = "mysql"
  instance_class                 = "db.m5.large"
  replicate_source_db            = aws_db_instance.primary.id
  db_subnet_group_name           = aws_db_subnet_group.main.name
  skip_final_snapshot           = true
  vpc_security_group_ids        = [var.security_group_id]
}


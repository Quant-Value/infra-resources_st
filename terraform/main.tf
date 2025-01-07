/*module "bucket_s3" {
  source      = "../modules/bucket_s3"
  aws_region  = var.aws_region    # Pasa la variable aws_region
  bucket_name = var.bucket_name   # Pasa la variable bucket_name
}*/

/*module "ec2_redhat" {
  source       = "../modules/ec2_redhat"
  aws_region   = var.aws_region   # Pasa la variable aws_region
  instance_type = var.instance_type # Pasa la variable instance_type
  ami_id        = var.ami_id       # Pasa la variable ami_id
}*/

# Llamar al módulo de red
module "network" {
  source = "../modules/rds_high_ava/network"
  create_replica= var.create_replica
  rds_replicas=var.rds_replicas
}

# Llamar al módulo de seguridad
module "security" {
  source = "../modules/rds_high_ava/security"
}

# Llamar al módulo de RDS
module "rds" {
  source = "../modules/rds_high_ava/rds"
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
  security_group_id = module.security.rds_security_group_id
  db_username=var.db_username
  db_password=var.db_password
  create_replica=var.create_replica
  rds_replicas=var.rds_replicas
}

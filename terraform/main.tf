
/*

module "bucket_s3" {
  source      = "../modules/bucket_s3"
  aws_region  = var.aws_region    # Pasa la variable aws_region
  bucket_name = var.bucket_name   # Pasa la variable bucket_name
}*/
/*
module "ec2_redhat" {
  source       = "../modules/ec2_redhat"
  aws_region   = var.aws_region   # Pasa la variable aws_region
  instance_type = var.instance_type # Pasa la variable instance_type
  ami_id        = var.ami_id       # Pasa la variable ami_id
}


*/
/*
resource "aws_s3_bucket" "bucket" {
    bucket = "campus-dual-grupo4-terraform-state-backend"
    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
    object_lock_configuration {
        object_lock_enabled = "Enabled"
    }
    tags = {
        Name = "S3 Remote Terraform State Store for grup 4"
    }
}
resource "aws_dynamodb_table" "terraform-lock" {
    name           = "stb_terraform_state"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table for stb user"
    }
}*/
/*
# Llamar al módulo de red
module "network" {
  source = "../modules/rds_high_ava/network"
  create_replica= var.create_replica
  rds_replicas=var.rds_replicas
  vpc_cidr=var.vpc_cidr
}

# Llamar al módulo de seguridad
module "security" {
  source = "../modules/rds_high_ava/security"
  vpc_cidr=var.vpc_cidr
  vpc_id = module.network.vpc_id
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
*/
/*
module "lambda" {
  source      = "../modules/lambda"
}
*/

/*
module "ec2_wordpress" {
  source       = "../modules/wordpress"
  instance_type = var.instance_type # Pasa la variable instance_type
  ami_id        = var.ami_id       # Pasa la variable ami_id
  private_key_path=var.private_key_path
  tag_value=var.tag_value#########
  aws_region = var.aws_region
  public_key_path = var.public_key_path
  module_path=var.module_path
  db_username=var.db_username
  db_password=var.db_password
  replicas=var.replicas

}
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.nginx-node-mongo.ec2_public_ip
}
*/
/*
module "nginx-node-mongo" {
    source       = "../modules/nginx-node-mongo"
  instance_type = var.instance_type # Pasa la variable instance_type
  ami_id        = var.ami_id       # Pasa la variable ami_id
  private_key_path=var.private_key_path
  tag_value=var.tag_value#########
  aws_region = var.aws_region
  public_key_path = var.public_key_path
  module_path=var.module_path
  replicas=var.replicas

}*//*
module "first_eks"{
  source = "../modules/eks"
  instance_type=var.instance_type
  private_key_path=var.private_key_path
  tag_value=var.tag_value
  public_key_path=var.public_key_path
  aws_region = var.aws_region

}*/

/*
data "terraform_remote_state" "eks" {
  backend = "s3"  # Usa el mismo backend S3 configurado en el proyecto EKS

  config = {
    bucket = "proyect-1-stb-devops-bucket"
    key    = "terraform/eks/terraform.tfstate"
    region = "eu-west-3"
  }

}
output "node_security_group_id_from_remote_state" {
  value = data.terraform_remote_state.eks.outputs.node_security_group_id
}*/

/*
module "word_eks"{
  source = "../modules/eks_wordpress"
  instance_type=var.instance_type
  tag_value=var.tag_value
  aws_region = var.aws_region
  replicas=var.replicas
  db_username=var.db_username
  db_password=var.db_password
  vpc_id=var.vpc_id
  subnets=var.subnets
  module_path=var.module_path
}*/

module "nginx_service"{
  source = "../modules/ecs_resources"
  tag_value=var.tag_value
  aws_region = var.aws_region
  vpc_id=var.vpc_id
  subnets=var.subnets
  db_username=var.db_username
  db_password=var.db_password
  replicas=var.replicas
  custom_nginx=var.custom_nginx
  custom_flask=var.custom_flask
  #sg=var.sg
}





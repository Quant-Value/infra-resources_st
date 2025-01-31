provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  aws_region = "eu-west-2" 
}

data "terraform_remote_state" "vpc" {

  backend = "s3" 
  config = {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3 donde está almacenado el estado
    key    = "terraform/vpc/terraform.tfstate"      # Ruta dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
  }
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [for subnet in data.terraform_remote_state.vpc.outputs.subnets_public_info : subnet.id]
  #subnets=["subnet-0a047a9f376ca5aea","subnet-08dfb6f51cfc57a18","subnet-00f9f04e1bc9a1499"]
}


terraform {
  backend "s3" {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/ecs/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

resource "aws_ecs_cluster" "mi_ecs" {
    name = "${local.tag_value}-cluster"
        setting {
            name = "containerInsights"
            value = "disabled"
        }
    tags = {
        Team = "Devops-bootcamp"
    }
}

output "ecs_cluster_id" {
  description = "El ID del clúster ECS creado"
  value       = aws_ecs_cluster.mi_ecs.id
}

output "ecs_cluster_name" {
  description = "El nombre del clúster ECS creado"
  value       = aws_ecs_cluster.mi_ecs.name
}


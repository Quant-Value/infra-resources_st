
provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  instance_type="t2.small" 
  aws_region = "eu-west-3" 
  vpc_id="vpc-002427d5be38383d7"
  subnets=["subnet-0db83f9cfe117f3ee", "subnet-0c9cbb71f54b20838","subnet-09e322a40eca323b9"]
}

terraform {
  backend "s3" {
    bucket = "proyect-1-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/ecs/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-3"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}


module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = "${local.tag_value}-ec2-cluster"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = ""
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 3
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "${tag_value}-proyect"
  }
}
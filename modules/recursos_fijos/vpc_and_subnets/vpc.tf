provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  bucket_name="proyect-2-stb-devops-bucket"
  aws_region = "eu-west-2" 

}



# Crear la VPC
resource "aws_vpc" "main" {
  cidr_block = "10.19.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "stb-vpc"
  }

}

terraform {
  backend "s3" {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/vpc/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC created"
}
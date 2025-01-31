provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  bucket_name="proyect-2-stb-devops-bucket"
  aws_region = "eu-west-2" 

}


resource "aws_s3_bucket" "my_bucket" {
  bucket = local.bucket_name  # Usamos el nombre del bucket desde una variable
  #acl    = var.acl          # Política de acceso, definida en la variable
  # Habilitar la versión de los objetos del bucket (opcional)
  versioning {
    enabled = false
  }
  lifecycle {#con esto no deja destruir
    prevent_destroy = false
  }
}

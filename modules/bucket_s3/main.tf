# Crear un bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name  # Usamos el nombre del bucket desde una variable
  #acl    = var.acl          # Política de acceso, definida en la variable
  # Habilitar la versión de los objetos del bucket (opcional)
  versioning {
    enabled = false
  }
  lifecycle {#con esto no deja destruir
    prevent_destroy = false
  }
}

terraform {
  backend "s3" {
    bucket = var.backend_bucket_name          # Nombre de tu bucket S3
    key    = "terragrunt/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-3"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}
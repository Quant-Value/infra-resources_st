# Crear un bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name  # Usamos el nombre del bucket desde una variable
  acl    = var.acl          # Política de acceso, definida en la variable
  # Habilitar la versión de los objetos del bucket (opcional)
  versioning {
    enabled = false
  }
  lifecycle {#con esto no deja destruir
    prevent_destroy = false
  }
}



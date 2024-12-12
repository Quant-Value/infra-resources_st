# Crear un bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name  # Usamos el nombre del bucket desde una variable
  #region = var.aws_region
  # Habilitar la versión de los objetos del bucket (opcional)
  versioning {
    enabled = false
  }
}



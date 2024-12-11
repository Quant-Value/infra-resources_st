# Crear un bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name  # Usamos el nombre del bucket desde una variable

  # Habilitar la versión de los objetos del bucket (opcional)
  versioning {
    enabled = false
  }
}

# Crear una instancia EC2 con el tipo c5.large y una AMI de Red Hat
resource "aws_instance" "redhat_instance" {
  ami           = var.ami_id  # Usamos la variable de la AMI
  instance_type = var.instance_type  # Usamos la variable del tipo de instancia

  # Configurar las etiquetas de la instancia
  tags = {
    Name = "RedHatInstance"
  }
}

# Crear una instancia EC2 con el tipo c5.large y una AMI de Red Hat
resource "aws_instance" "redhat_instance" {
  ami           = "ami-0574a94188d1b84a1"  # Usamos la variable de la AMI
  instance_type = var.instance_type  # Usamos la variable del tipo de instancia
  #region= var.aws_region
  # Configurar las etiquetas de la instancia
  tags = {
    Name = "RedHatInstance-stb"
  }
}

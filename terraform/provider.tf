# Configuración del proveedor AWS
provider "aws" {
  region = var.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf
  profile = "default"
}

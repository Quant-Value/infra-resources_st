# Declaración de variables

variable "aws_region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  #default     = "eu-west-3"  # Valor por defecto para la región (París)
}

variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}
variable "acl" {
  description = "Política de acceso al bucket"
  type        = string
  default     = "private"  # Valor por defecto para la política de acceso
}

variable "backend_bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}
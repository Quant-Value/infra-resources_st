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

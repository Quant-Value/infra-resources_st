# Declaración de variables

variable "aws_region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  #default     = "eu-west-3"  # Valor por defecto para la región (París)
}

variable "ami_id" {
  description = "ID de la AMI de Red Hat en la región especificada"
  type        = string
}

variable "instance_type" {
  description = "Tipo de la instancia EC2"
  type        = string
  #default     = "c5.large"  # Valor por defecto para el tipo de instancia
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
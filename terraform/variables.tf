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

variable "acl" {
  description = "Política de acceso al bucket"
  type        = string
  default     = "private"  # Valor por defecto para la política de acceso
}

variable "db_username" {
  type = string
  sensitive= true  # Esto marca la variable como sensible
}

variable "db_password" {
  type = string
  sensitive = true  # Esto marca la variable como sensible
}
variable "create_replica" {
  description = "Indica si se debe crear una réplica de la base de datos"
  type        = bool
  default     = false  # Valor por defecto, si no se pasa valor, no se crea la réplica
}
variable "replicas" {
  description = "Indica la cantidad de replicas de rds"
  type        = number
}
variable "vpc_cidr" {
  description = "Rango de direcciones CIDR para la VPC"
  type        = string
}
variable "private_key_path" {
  description = "Ruta al archivo privado de la clave SSH"
  type        = string
}/*
variable "backend_bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}*/
variable "tag_value" {
  description = "El valor del tag para el recurso"
  type        = string
}
variable "public_key_path" {
  description = "Ruta al archivo privado de la clave SSH"
  type        = string
}
variable "module_path" {
  type        = string
}


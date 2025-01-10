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

variable "db_username" {
  type = string
  default = ""
  sensitive = true  # Esto marca la variable como sensible
}

variable "db_password" {
  type = string
  default = ""
  sensitive = true  # Esto marca la variable como sensible
}
variable "create_replica" {
  description = "Indica si se debe crear una réplica de la base de datos"
  type        = bool
  default     = false  # Valor por defecto, si no se pasa valor, no se crea la réplica
}
variable "rds_replicas" {
  description = "Indica la cantidad de replicas de rds"
  type        = number
  default     = 1  # Valor por defecto, si no se pasa valor, no se crea la réplica
}
variable "vpc_cidr" {
  description = "Rango de direcciones CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "private_key_path" {
  description = "Ruta al archivo privado de la clave SSH"
  type        = string
}

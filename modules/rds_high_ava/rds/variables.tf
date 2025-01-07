variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subredes privadas"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID del grupo de seguridad de RDS"
  type        = string
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
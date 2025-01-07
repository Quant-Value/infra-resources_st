variable "vpc_cidr" {
  description = "Rango de direcciones CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
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
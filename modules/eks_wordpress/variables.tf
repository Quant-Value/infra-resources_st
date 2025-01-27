# Declaración de variables

variable "instance_type" {
  description = "Tipo de la instancia EC2"
  type        = string
  #default     = "c5.large"  # Valor por defecto para el tipo de instancia
}

# variables.tf
variable "tag_value" {
  description = "El valor del tag para el recurso"
  type        = string
}

variable "aws_region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  #default     = "eu-west-3"  # Valor por defecto para la región (París)
}
variable "module_path" {
  type        = string
}
variable "replicas" {
  description = "Indica la cantidad de replicas de rds"
  type        = number
}
variable "db_username" {
  type = string
  sensitive= true  # Esto marca la variable como sensible
}

variable "db_password" {
  type = string
  sensitive = true  # Esto marca la variable como sensible
}

variable "vpc_id" {

  type        = string
}

variable "subnets" {

  type        = list
}

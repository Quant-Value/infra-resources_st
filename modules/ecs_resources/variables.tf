variable "vpc_id" {

  type        = string
}

variable "subnets" {

  type        = list
}

variable "aws_region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  #default     = "eu-west-3"  # Valor por defecto para la región (París)
}
variable "tag_value" {
  description = "El valor del tag para el recurso"
  type        = string
}

variable "db_username" {
  type = string
  sensitive= true  # Esto marca la variable como sensible
}

variable "db_password" {
  type = string
  sensitive = true  # Esto marca la variable como sensible
}
variable "replicas"{
  type = number
}

variable "custom_flask" {
  type        = string
}
variable "custom_nginx" {
  type        = string
}
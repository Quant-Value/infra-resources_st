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
variable "instance_type" {
  description = "Tipo de la instancia EC2"
  type        = string
  #default     = "c5.large"  # Valor por defecto para el tipo de instancia
}
variable "aws_region" {
  description = "La región de AWS donde se desplegarán los recursos"
  type        = string
  #default     = "eu-west-3"  # Valor por defecto para la región (París)
}
variable "private_key_path" {
  description = "Ruta al archivo privado de la clave SSH"
  type        = string
}
variable "tag_value" {
  description = "El valor del tag para el recurso"
  type        = string
}
variable "public_key_path" {
  description = "Ruta al archivo privado de la clave SSH"
  type        = string
}
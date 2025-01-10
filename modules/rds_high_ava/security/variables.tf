variable "vpc_cidr" {
  description = "Rango de direcciones CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
} 
variable "vpc_id" {
  description = "Id de VPC"
  type        = string

}

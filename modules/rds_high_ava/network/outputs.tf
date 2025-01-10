output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}
output "vpc_cidr"{
  value = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  description = "IDs de las subredes privadas"
  value       = [for subnet in aws_subnet.private_subnets : subnet.id]
}

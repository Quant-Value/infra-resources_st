output "rds_security_group_id" {
  description = "ID del grupo de seguridad de RDS"
  value       = aws_security_group.rds_security_group.id
}

output "rds_primary_endpoint" {
  description = "Endpoint de la instancia principal de RDS"
  value       = aws_db_instance.primary.endpoint
}

output "rds_replica_endpoint" {
  description = "Endpoint de las réplicas de RDS"
  value       = [for replica in aws_db_instance.replica : replica.endpoint]
}

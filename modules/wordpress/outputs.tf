# Output para mostrar la IP pública de la instancia EC2 y el endpoint de la base de datos MySQL
output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}
output "rds_user"{
    value=aws_db_instance.mysql_db.username
    sensitive = true
}
output "rds_password"{
    value=aws_db_instance.mysql_db.password
    sensitive = true
}
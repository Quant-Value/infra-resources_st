# Output de la ID de la instancia EC2
output "instance_id" {
  value = aws_instance.ubuntu_instance.id
  description = "ID de la instancia EC2"
}
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ubuntu_instance.public_ip
}

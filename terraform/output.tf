# Output de la ID de la instancia EC2
output "instance_id" {
  value = aws_instance.redhat_instance.id
  description = "ID de la instancia EC2"
}

# Output del nombre del bucket S3
output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
  description = "Nombre del bucket S3"
}

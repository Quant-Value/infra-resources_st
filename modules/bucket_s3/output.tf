# Output del nombre del bucket S3
output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
  description = "Nombre del bucket S3"
}

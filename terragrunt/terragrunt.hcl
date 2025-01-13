/*remote_state {
    backend ="s3" 
    config = {
        bucket         = "proyect-1-stb-devops-bucket"  # Nombre del bucket S3
        key            = "terragrunt/state/file.tfstate"  # Ruta dentro del bucket S3
        region         = "eu-west-3"
        encrypt        = true  # Encriptar el archivo de estado
        #dynamodb_table = "my-lock-table"  # Usar DynamoDB para el bloqueo de estado
        #acl            = "private"  # ACL del bucket, usualmente "private"
  }
}


terraform {
    #source="./"
    source="../modules/bucket_s3"
    #bucket_name="Mynonuniquebucketfromstbtoday"
    #acl= "public-read"

    
}
inputs = {
  aws_region = "eu-west-3"
  bucket_name = "my-dev-bucketforstbfromtoday"
  acl          = "public-read"
  backend_bucket_name= "proyect-1-stb-devops-bucket"
}*/
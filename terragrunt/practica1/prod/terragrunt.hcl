locals{
    enviroment= "prod"
    backend_bucket_name= "proyect-1-stb-devops-bucket"
    aws_region = "eu-west-3"
    
}

remote_state {
    backend ="s3" 
    config = {
        bucket         = local.backend_bucket_name  # Nombre del bucket S3
        key            = "terragrunt/${local.enviroment}/file.tfstate"  # Ruta dentro del bucket S3
        region         = local.aws_region
        encrypt        = true  # Encriptar el archivo de estado
        #dynamodb_table = "my-lock-table"  # Usar DynamoDB para el bloqueo de estado
        #acl            = "private"  # ACL del bucket, usualmente "private"
  }
}


terraform {
    #source="./"
    source="../../../modules/bucket_s3"

}
inputs = {
  bucket_name = "my-dev-bucketfor-stb-fromtoday-${local.enviroment}"
  acl          = "public-read"
  aws_region= local.aws_region
  backend_bucket_name = local.backend_bucket_name
}
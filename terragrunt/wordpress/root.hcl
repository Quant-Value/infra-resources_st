locals {
    aws_region = "eu-west-3"
    backend_bucket_name= "proyect-1-stb-devops-bucket"
}


remote_state {
    backend ="s3"
    generate={
        path="backend.tf"
         if_exists = "overwrite"
    } 
    config = {
        bucket         =  local.backend_bucket_name   # Nombre del bucket S3
        key            = "terragrunt/${path_relative_to_include()}/file.tfstate"  # Ruta dentro del bucket S3
        region         = local.aws_region
        encrypt        = true  # Encriptar el archivo de estado
        #dynamodb_table = "my-lock-table"  # Usar DynamoDB para el bloqueo de estado
        #acl            = "private"  # ACL del bucket, usualmente "private"
  }
}



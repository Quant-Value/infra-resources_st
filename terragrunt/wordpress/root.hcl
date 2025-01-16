locals{
    aws_region = "eu-west-3"
    backend_bucket_name= "proyect-1-stb-devops-bucket"
    tag_value="stb"
    instance_type = "t2.micro" 
    ami_id= "ami-07db896e164bc4476"
    private_key_path = "~/.ssh/id_rsa" 
    public_key_path = "~/.ssh/id_rsa.pub" 

}

remote_state {
    backend ="s3" 
    config = {
        bucket         =  local.backend_bucket_name   # Nombre del bucket S3
        key            = "terragrunt/${path_relative_to_include()}/file.tfstate"  # Ruta dentro del bucket S3
        region         = local.aws_region
        encrypt        = true  # Encriptar el archivo de estado
        #dynamodb_table = "my-lock-table"  # Usar DynamoDB para el bloqueo de estado
        #acl            = "private"  # ACL del bucket, usualmente "private"
  }
}

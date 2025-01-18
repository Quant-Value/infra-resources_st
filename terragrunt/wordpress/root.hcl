locals {
    aws_region = "eu-west-3"
    #backend_bucket_name= "proyect-1-stb-devops-bucket"
    vars=read_terragrunt_config(find_in_parent_folders("all-common.hcl"))
    #porque debe buscar en la carpeta "padre" porque  este fichero se lleva hasta el subdirectorio del entorno y es desde ahi donde se llama a all-common.hcl de otra manera falla al intentar traerlo
}


remote_state {
    backend ="s3"
    generate={
        path="backend.tf"
         if_exists = "overwrite"
    } 
    config = {
        bucket         = local.vars.inputs.backend_bucket_name   # Nombre del bucket S3
        key            = "terragrunt/${path_relative_to_include()}/file.tfstate"  # Ruta dentro del bucket S3
        region         = local.aws_region
        encrypt        = true  # Encriptar el archivo de estado
        #dynamodb_table = "my-lock-table"  # Usar DynamoDB para el bloqueo de estado
        #acl            = "private"  # ACL del bucket, usualmente "private"
  }
}



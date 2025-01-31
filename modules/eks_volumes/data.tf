data "terraform_remote_state" "ecr" {

  backend = "s3" 
  config = {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3 donde está almacenado el estado
    key    = "terraform/ecr/terraform.tfstate"      # Ruta dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
  }
}

locals {
    ecr_url=data.terraform_remote_state.ecr.outputs.repository_url
}


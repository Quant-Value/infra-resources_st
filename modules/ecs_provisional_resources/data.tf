data "terraform_remote_state" "ecs" {
  backend = "s3"  # Usa el mismo backend S3 configurado en el proyecto EKS

  config = {
    bucket = "proyect-1-stb-devops-bucket"
    key    = "terraform/ecs/terraform.tfstate"
    region = "eu-west-3"
  }

}
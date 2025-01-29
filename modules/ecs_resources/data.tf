data "terraform_remote_state" "ecs" {
  backend = "s3"  # Usa el mismo backend S3 configurado en el proyecto EKS

  config = {
    bucket = "proyect-1-stb-devops-bucket"
    key    = "terraform/ecs/terraform.tfstate"
    region = "eu-west-3"
  }

}

data "aws_ssm_parameter" "container_image_flask" {
  name = "/${var.tag_value}/image/flask"
  depends_on=[aws_ssm_parameter.container_image_flask]
}
data "aws_ssm_parameter" "container_image_nginx" {
  name = "/${var.tag_value}/image/nginx"
  depends_on=[aws_ssm_parameter.container_image_nginx]
}
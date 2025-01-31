provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  aws_region = "eu-west-2" 

}
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


terraform {
  backend "s3" {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/31-01-chatbot/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

data "template_file" "nginx_deployment_yaml" {
  template = file("${path.module}/chat-deploy.tpl")

  vars = {
    ecr_url = "${local.ecr_url}:chat-bot"
  }
}


resource "kubernetes_manifest" "nginx_deployment" {
  manifest = yamldecode(data.template_file.nginx_deployment_yaml.rendered)
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}
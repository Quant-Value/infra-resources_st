provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  aws_region = "eu-west-2" 

}

terraform {
  backend "s3" {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/nginx_deployment/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

/*
# Generar el archivo YAML para el Deployment de Kubernetes
resource "template_file" "nginx_deployment_yaml" {#acceso a nginx mediante alb/web/
  template = file("${path.module}/nginx_deployment.tpl")

  vars = {
    ecr_url = "${local.ecr_url}:custom-nginx"
  }
}*/
data "template_file" "nginx_deployment_yaml" {
  template = file("${path.module}/nginx_deployment.tpl")

  vars = {
    ecr_url = "${local.ecr_url}:custom-nginx"
  }
}

/*
# Crear el recurso de Kubernetes Deployment utilizando el archivo generado
resource "kubernetes_manifest" "nginx_deployment" {
  manifest = yamldecode(template_file.nginx_deployment_yaml.rendered)
}*/
resource "kubernetes_manifest" "nginx_deployment" {
  manifest = yamldecode(data.template_file.nginx_deployment_yaml.rendered)
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}
#248189943700.dkr.ecr.eu-west-2.amazonaws.com/stb-my-ecr-repo:custom-nginx
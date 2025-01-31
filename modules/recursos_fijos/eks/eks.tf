provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}

locals {
  tag_value="stb"
  instance_type="t2.small" 
  aws_region = "eu-west-2" 
}

# Acceder al estado remoto de otro módulo que contiene la VPC y las subnets
data "terraform_remote_state" "vpc" {

  backend = "s3" 
  config = {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3 donde está almacenado el estado
    key    = "terraform/vpc/terraform.tfstate"      # Ruta dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
  }
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [for subnet in data.terraform_remote_state.vpc.outputs.subnets_public_info : subnet.id]
  #subnets=["subnet-0a047a9f376ca5aea","subnet-08dfb6f51cfc57a18","subnet-00f9f04e1bc9a1499"]
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
 
  cluster_name    = "mi-cluster-${local.tag_value}"
  cluster_version = "1.32"
 
  vpc_id     = local.vpc_id
  subnet_ids = local.subnets
   # Configuración de acceso público y privado (se puede configurar usando `cluster_endpoint_public_access` y `cluster_endpoint_private_access`)
  cluster_endpoint_public_access = true  # Permitir acceso público
  cluster_endpoint_private_access = true  # Deshabilitar acceso privado (opcional, según necesidad)

  eks_managed_node_groups = {
    grupo-nodos = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
 
      instance_types = [local.instance_type]
    }
  }

}
# Proveedor de Kubernetes usando el config_path de kubeconfig
provider "kubernetes" {
  config_path = "~/.kube/config"
}

terraform {
  backend "s3" {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/eks/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = try(module.eks.node_security_group_id, null)
}
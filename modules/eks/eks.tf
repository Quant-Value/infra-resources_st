provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  instance_type="t2.small" 
  aws_region = "eu-west-3" 
  vpc_id="vpc-002427d5be38383d7"
  subnets=["subnet-0db83f9cfe117f3ee", "subnet-0c9cbb71f54b20838","subnet-09e322a40eca323b9"]
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
 
  cluster_name    = "mi-cluster-${local.tag_value}"
  cluster_version = "1.31"
 
  vpc_id     = local.vpc_id
  subnet_ids = local.subnets
   # Configuración de acceso público y privado (se puede configurar usando `cluster_endpoint_public_access` y `cluster_endpoint_private_access`)
  cluster_endpoint_public_access = true  # Permitir acceso público
  cluster_endpoint_private_access = true  # Deshabilitar acceso privado (opcional, según necesidad)

  eks_managed_node_groups = {
    mi-nodo-grupo = {
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
    bucket = "proyect-1-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/eks/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-3"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = try(module.eks.node_security_group_id, null)
}
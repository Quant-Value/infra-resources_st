provider "aws" {
  region = "eu-west-3"  # Usamos una variable para la región, que podemos definir en variables.tf
  #profile = "default"
  #quitar profile si se compila desde la nube
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
 
  cluster_name    = "mi-cluster-stb-facil"
  cluster_version = "1.31"
 
  vpc_id     = "vpc-002427d5be38383d7"
  subnet_ids = ["subnet-0db83f9cfe117f3ee", "subnet-0c9cbb71f54b20838","subnet-09e322a40eca323b9"]
   # Configuración de acceso público y privado (se puede configurar usando `cluster_endpoint_public_access` y `cluster_endpoint_private_access`)
  cluster_endpoint_public_access = true  # Permitir acceso público
  cluster_endpoint_private_access = true  # Deshabilitar acceso privado (opcional, según necesidad)

  eks_managed_node_groups = {
    mi-nodo-grupo = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
 
      instance_types = ["t2.small"]
    }
  }

}
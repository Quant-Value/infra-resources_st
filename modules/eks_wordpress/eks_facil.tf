/*

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
 
  cluster_name    = "mi-cluster-${var.tag_value}"
  cluster_version = "1.31"
 
  vpc_id     = var.vpc_id
  subnet_ids = var.subnets
   # Configuración de acceso público y privado (se puede configurar usando `cluster_endpoint_public_access` y `cluster_endpoint_private_access`)
  cluster_endpoint_public_access = true  # Permitir acceso público
  cluster_endpoint_private_access = true  # Deshabilitar acceso privado (opcional, según necesidad)

  eks_managed_node_groups = {
    mi-nodo-grupo = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
 
      instance_types = [var.instance_type]
    }
  }

}
# Proveedor de Kubernetes usando el config_path de kubeconfig

*/
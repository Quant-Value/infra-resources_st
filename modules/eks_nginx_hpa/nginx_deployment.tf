
# proveedor de kubernetes (usa el provider configurado en tu módulo de EKS)
provider "kubernetes" {
  config_path="~/.kube/config"
}
provider "aws" {
  region = "eu-west-3"  # Usamos una variable para la región, que podemos definir en variables.tf
  #profile = "default"
  #quitar profile si se compila desde la nube
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "saltardevops/images:latestv2"
          name  = "nginx"
          port {
            container_port = 80
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "512Mi"
            }
          }
          }
          
        }
      }
    }
  }






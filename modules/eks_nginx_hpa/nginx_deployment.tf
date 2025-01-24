
# proveedor de kubernetes (usa el provider configurado en tu módulo de EKS)
provider "kubernetes" {
  config_path="~/.kube/config"
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









resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"  # Apunta al Deployment de NGINX
    }

    port {
      port        = 80           # Puerto expuesto en el LoadBalancer
      target_port = 80           # Puerto dentro del contenedor (NGINX)
    }

    type = "LoadBalancer"         # Tipo de servicio LoadBalancer
  }
}

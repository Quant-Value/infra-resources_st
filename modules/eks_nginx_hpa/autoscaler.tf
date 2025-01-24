
resource "kubernetes_horizontal_pod_autoscaler" "nginx_autoscaler" {
  metadata {
    name      = "nginx-hpa"
    namespace = "default"  # Puedes especificar otro namespace si es necesario
  }

  spec {
    max_replicas = 10  # Número máximo de réplicas que puedes escalar
    min_replicas = 2   # Número mínimo de réplicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name  # Referencia al nombre del deployment NGINX
    }
    target_cpu_utilization_percentage = 40 #para no _v1 se usa este parametro.
    /*
    metrics {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                 = "Utilization"
          average_utilization  = 50  # Valor de CPU objetivo para el escalado
        }
      }
    }*/
  }
}

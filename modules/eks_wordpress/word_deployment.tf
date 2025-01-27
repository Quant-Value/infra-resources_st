
provider "kubernetes" {
  config_path = "~/.kube/config"
}
# Crear el deployment para WordPress
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress-deployment"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 2  # Definir el número de réplicas

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          name  = "wordpress"
          image = "wordpress:latest"
          port {
            container_port = 80  # Puerto en el contenedor
          }

          # Recursos asignados al contenedor (opcional, pero recomendado)
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

          env{
            name="WORDPRESS_DB_NAME"
            value=aws_db_instance.mysql_db.db_name
          }
          env{
            name="WORDPRESS_DB_USER"
            value=var.db_username
          }
          env{
            name="WORDPRESS_DB_PASSWORD"
            value=var.db_password
          }
          env{
            name="WORDPRESS_DB_HOST"
            value=aws_db_instance.mysql_db.endpoint
          }
        }
        
        
      }
    }
  }
}

# Crear un servicio para exponer el Deployment de WordPress
resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.wordpress.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"  # Para acceder a WordPress desde fuera del clúster
  }
}








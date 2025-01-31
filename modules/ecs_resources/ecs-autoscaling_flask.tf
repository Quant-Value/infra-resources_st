#Cloud watch metrica personalizada (ventana de tiempo mas pequeña)


# Crear el objetivo de autoescalado para ECS
resource "aws_appautoscaling_target" "ecs_scaling_flask" {
  service_namespace = "ecs"
  resource_id = "service/${data.terraform_remote_state.ecs.outputs.ecs_cluster_name}/${aws_ecs_service.flask_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = 1
  max_capacity = 3
}

/*
resource "aws_appautoscaling_policy" "http_request_scaling_flask" {
  name               = "http-request-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_flask.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_flask.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_flask.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 3000  # Número de solicitudes HTTP objetivo para escalar

      predefined_metric_specification{
        predefined_metric_type = "ALBRequestCountPerTarget"
        resource_label = join("",[
          "app",
          split("app",aws_lb.my_alb.id)[1],
          "/targetgroup",
          split("targetgroup",aws_lb_target_group.ecs_targets2.id)[1]

        ])
      }
    

    scale_in_cooldown  = 120  # 5 minutos para esperar después de escalar hacia abajo
    scale_out_cooldown = 60  # 5 minutos para esperar después de escalar hacia arriba
  }
}
*/
/*
resource "aws_appautoscaling_policy" "http_request_scaling_flask" { #no funciona  y la idea era que la metrica fuese (requestcount-target-group2)/(nº instancias tareas flask)
  name               = "http-request-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_flask.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_flask.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_flask.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 3000  # Número objetivo de solicitudes por tarea (solicitudes/tareas >= 3000)

    customized_metric_specification {
      metrics {
        label = "ALBRequestCountPerTarget"
        id    = "m1"

        metric_stat {
          metric {
            metric_name = "RequestCount"
            namespace   = "AWS/ApplicationELB"
            dimensions {
              name  = "TargetGroup"
              value = aws_lb_target_group.ecs_targets2.name  # Especifica el nombre de tu TargetGroup
            }
          }
          stat = "Sum"
        }

        return_data = false
      }

      metrics {
        label = "RunningTaskCount"
        id    = "m2"

        metric_stat {
          metric {
            metric_name = "RunningTaskCount"
            namespace   = "AWS/ECS"
            dimensions {
              name  = "ClusterName"
              value = "stb-cluster"  # Nombre de tu clúster ECS
            }
            dimensions {
              name  = "ServiceName"
              value = "service:flask-service"  # Nombre de tu servicio ECS
            }
          }
          stat = "Maximum"
        }

        return_data = false
      }

      metrics {
        label       = "RequestsPerTask"
        id          = "e1"
        expression  = "m1 / m2"
        return_data = true
      }
    }

    scale_in_cooldown  = 120  # 2 minutos de espera después de escalar hacia abajo
    scale_out_cooldown = 60   # 1 minuto de espera después de escalar hacia arriba
  }
}
*/


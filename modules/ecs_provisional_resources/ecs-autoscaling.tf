

# Crear el objetivo de autoescalado para ECS
resource "aws_appautoscaling_target" "ecs_scaling" {
  service_namespace = "ecs"
  resource_id = "service/${data.terraform_remote_state.ecs.outputs.ecs_cluster_name}/${aws_ecs_service.nginx_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = 1
  max_capacity = 5
}

# Crear la política de escalado basada en el uso de CPU
resource "aws_appautoscaling_policy" "cpu_scaling" {
  name               = "cpu-scaling"
  #scaling_target_id  = aws_appautoscaling_target.ecs_scaling.id
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling.service_namespace
  
  target_tracking_scaling_policy_configuration {
    target_value = 50.0  # El valor objetivo de CPU que queremos mantener (50%)
    
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"  # Métrica predeterminada de utilización de CPU
    }

    # Tiempo de espera (cooldown) para aumentar o reducir la capacidad
    scale_in_cooldown  = 300  # 5 minutos para esperar después de escalar hacia abajo
    scale_out_cooldown = 300  # 5 minutos para esperar después de escalar hacia arriba
  }
}

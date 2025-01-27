


resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.tag_value}vecs-task-sg"
  description = "Security group for ECS task"
  vpc_id      = var.vpc_id

  # Permitir tráfico de las instancias del ALB en el puerto 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Permite tráfico desde el ALB
    description = "Allow HTTP traffic from ALB"
  }

  # Regla de salida (permitir todo el tráfico de salida)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.tag_value}ecs-task-sg"
  }
}


resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_id # Aquí se especifica el cluster donde se ejecutará la tarea
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1

  launch_type = "FARGATE"  # Especificamos FARGATE como el tipo de lanzamiento

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true

    security_groups = [aws_security_group.ecs_service_sg.id] # Aquí agregas el security group necesario
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_targets.arn
    container_name   = "nginx-container"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  requires_compatibilities = ["FARGATE"]
  network_mode= "awsvpc"
  cpu         = 256
  memory      = 512

  container_definitions = jsonencode([
    {
      name        = "nginx-container"
      image       = "nginx:latest"
      cpu         = 256
      memory      = 512
      essential   = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

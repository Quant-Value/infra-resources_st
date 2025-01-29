


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
  family                   = "nginx-task-${var.tag_value}"
  requires_compatibilities = ["FARGATE"]
  network_mode= "awsvpc"
  cpu         = 256
  memory      = 1024
  #task_role_arn            = aws_iam_role.ecs_task_role.arn  # IAM role para los permisos de la tarea
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = "nginx-container"
      image       = data.aws_ssm_parameter.container_image_nginx.value
      #image =  var.custom_nginx
      cpu         = 128
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

# --------- FLASK
resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_id # Aquí se especifica el cluster donde se ejecutará la tarea
  task_definition = aws_ecs_task_definition.flask_task.arn
  desired_count   = 1

  launch_type = "FARGATE"  # Especificamos FARGATE como el tipo de lanzamiento

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true

    security_groups = [aws_security_group.ecs_service_sg.id] # Aquí agregas el security group necesario
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_targets2.arn
    container_name   = "flask-container"
    container_port   = 80
  }

}

resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-task-${var.tag_value}"
  requires_compatibilities = ["FARGATE"]
  network_mode= "awsvpc"
  cpu         = 256
  memory      = 1024
  #task_role_arn            = aws_iam_role.ecs_task_execution_role.arn  # IAM role para los permisos de la tarea
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = "flask-container"
      image       = data.aws_ssm_parameter.container_image_flask.value
      #image =  var.custom_flask
      cpu         = 128
      memory      = 512
      essential   = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/${var.tag_value}/ecs/flask-task-logs"        # Nombre del grupo de logs en CloudWatch
          "awslogs-region"        = "${var.aws_region}"                 # Región de AWS
          "awslogs-stream-prefix" = "flask"                # Prefijo para el nombre de los flujos de logs
        }
      }
    }
  ])
}
#------------- WORDPRESS


resource "aws_ecs_service" "wp_service" {
  name            = "wp-service"
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_id # Aquí se especifica el cluster donde se ejecutará la tarea
  task_definition = aws_ecs_task_definition.wp_task.arn
  desired_count   = 1

  launch_type = "FARGATE"  # Especificamos FARGATE como el tipo de lanzamiento

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true

    security_groups = [aws_security_group.ecs_service_sg.id] # Aquí agregas el security group necesario
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_targets3.arn
    container_name   = "wp-container"
    container_port   = 80
  }

}

resource "aws_ecs_task_definition" "wp_task" {
  family                   = "wp-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  #task_role_arn            = aws_iam_role.ecs_task_role.arn  # Referencia al role IAM para acceder a los secretos
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = "wp-container"
      image       = "wordpress:latest"
      cpu         = 128
      memory      = 512
      essential   = true
      secrets = [
        {
          name      = "WORDPRESS_DB_USER"
          valueFrom = "arn:aws:secretsmanager:eu-west-3:248189943700:secret:my-rds-secret-stb-f2bWZk:username::"
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:eu-west-3:248189943700:secret:my-rds-secret-stb-f2bWZk:password::"
        },
        {
          name      = "WORDPRESS_DB_NAME"
          valueFrom = "arn:aws:secretsmanager:eu-west-3:248189943700:secret:my-rds-secret-stb-f2bWZk:name::"
        },
        {
          name      = "WORDPRESS_DB_HOST"
          valueFrom = "arn:aws:secretsmanager:eu-west-3:248189943700:secret:my-rds-secret-stb-f2bWZk:endpoint::"
        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/${var.tag_value}/ecs/wp-task-logs"        # Nombre del grupo de logs en CloudWatch
          "awslogs-region"        = "${var.aws_region}"                 # Región de AWS
          "awslogs-stream-prefix" = "wordpress"                # Prefijo para el nombre de los flujos de logs
        }
      }
    }
  ])
}
/*
resource "aws_ecs_task_definition" "wp_task" {
  family                   = "wp-task-${var.tag_value}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  #task_role_arn            = aws_iam_role.ecs_task_role.arn  # Referencia al role IAM para acceder a los secretos
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = "wp-container"
      image       = "wordpress:latest"
      cpu         = 256
      memory      = 512
      essential   = true

      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = aws_db_instance.mysql_db.endpoint  # Usamos la variable de Terraform

        },
        {
          name  = "WORDPRESS_DB_USER"
          value = var.db_username  # Usamos la variable de Terraform

        },
        {
          name  = "WORDPRESS_DB_PASSWORD"
          value = var.db_password  # Usamos la variable de Terraform

        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = aws_db_instance.mysql_db.db_name  # Usamos la variable de Terraform

        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/${var.tag_value}/ecs/wp-task-logs"        # Nombre del grupo de logs en CloudWatch
          "awslogs-region"        = "${var.aws_region}"                 # Región de AWS
          "awslogs-stream-prefix" = "wordpress"                # Prefijo para el nombre de los flujos de logs
        }
      }
    }
  ])
}

*/





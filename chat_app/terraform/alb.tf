
data "terraform_remote_state" "vpc" {

  backend = "s3" 
  config = {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3 donde está almacenado el estado
    key    = "terraform/vpc/terraform.tfstate"      # Ruta dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
  }
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [for subnet in data.terraform_remote_state.vpc.outputs.subnets_public_info : subnet.id]
}



resource "aws_security_group" "alb_sg" {
  name        = "${local.tag_value}ecs-alb-sg"
  description = "Security group for ALB"
  vpc_id      = local.vpc_id

  # Reglas de entrada para el ALB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }



  # Reglas de salida (permitir todo el tráfico de salida)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${local.tag_value}ecs-alb-sg"
  }
}

# Crear el Application Load Balancer (ALB)
resource "aws_lb" "my_alb" {
  name               = "ecs-alb-${local.tag_value}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.subnets
  enable_deletion_protection = false


  tags = {
    Name = "${local.tag_value}ecs-alb"
  }
}

# Crear el Target Group
resource "aws_lb_target_group" "ecs_targets" {
  name     = "${local.tag_value}ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  target_type="ip"

  /*health_check {
    interval            = 45
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }*/
  


  tags = {
    Name = "${local.tag_value}ecs-target-group"
  }
}

resource "aws_lb_listener" "my_lb_listener_80" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code     = 404
      content_type    = "text/plain"
      message_body    = "Path not found"
    }
  }
}
resource "aws_lb_listener_rule" "my_lb_listener_rule_web_foward" {
  listener_arn = aws_lb_listener.my_lb_listener_80.arn
  priority     = 20  # Prioridad de la regla, asegúrate de que no se solape con otras

  action {
    type             = "redirect"
    redirect {
      host = "a378f3df40d34440599db87b101c140b-1173671258.eu-west-2.elb.amazonaws.com"  # Dirección IP o dominio al que se redirige
      port = "80"                 # Puerto al que redirige (opcional, puedes usar 80 si es HTTP)
      protocol = "HTTP"           # Protocolo (puedes usar "HTTPS" si es necesario)
      status_code = "HTTP_301"    # Código de redirección (301 para redirección permanente)
    }
  }
  

  condition {
    path_pattern{
    values = ["/*"]
    }
  }
}
provider "aws" {
  region = var.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}

resource "aws_security_group" "alb_sg" {
  name        = "${var.tag_value}ecs-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

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
    Name = "${var.tag_value}ecs-alb-sg"
  }
}

# Crear el Application Load Balancer (ALB)
resource "aws_lb" "my_alb" {
  name               = "ecs-alb-${var.tag_value}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets
  enable_deletion_protection = false


  tags = {
    Name = "${var.tag_value}ecs-alb"
  }
}

# Crear el Target Group
resource "aws_lb_target_group" "ecs_targets" {
  name     = "${var.tag_value}ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type="ip"

  health_check {
    interval            = 45
    path                = "/web/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.tag_value}ecs-target-group"
  }
}

resource "aws_lb_target_group" "ecs_targets2" {
  name     = "${var.tag_value}ecs-target-group2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type="ip"

  health_check {
    interval            = 45
    path                = "/api"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.tag_value}ecs-target-group2"
  }
}
resource "aws_lb_target_group" "ecs_targets3" {
  name     = "${var.tag_value}ecs-target-group3"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type="ip"

  health_check {
    interval            = 45
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.tag_value}ecs-target-group3"
  }
}


# Listener del ALB en el puerto 80
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

#--------------- Foward rules

resource "aws_lb_listener_rule" "my_lb_listener_rule_web_foward" {
  listener_arn = aws_lb_listener.my_lb_listener_80.arn
  priority     = 20  # Prioridad de la regla, asegúrate de que no se solape con otras

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_targets.arn
  }
  

  condition {
    path_pattern{
    values = ["/web*"]
    }
  }
}


resource "aws_lb_listener_rule" "my_lb_listener_rule_api_forward" {
  listener_arn = aws_lb_listener.my_lb_listener_80.arn
  priority     = 21  # Prioridad de la regla, asegúrate de que no se solape con otras

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_targets2.arn
  }

  condition {
    path_pattern{
    values = ["/api*"]
    }
  }
}

resource "aws_lb_listener_rule" "my_lb_listener_rule_wp_forward" {
  listener_arn = aws_lb_listener.my_lb_listener_80.arn
  priority     = 22  # Prioridad de la regla, asegúrate de que no se solape con otras

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_targets3.arn
  }

  condition {
    path_pattern{
    values = ["/wp-*","/"]
    }
  }
}





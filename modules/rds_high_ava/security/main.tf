resource "aws_security_group" "rds_security_group" {
  name        = "stb-rds-high-availability"
  description = "Security group para RDS Multi-AZ"
  vpc_id= var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #cidr_blocks = ["10.15.0.0/16"]
    cidr_blocks = [var.vpc_cidr]
  }
  tags = {
    Name = "stb-security-group"  # Etiqueta adicional para identificarlo en la consola
  }
}

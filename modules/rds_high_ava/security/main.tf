resource "aws_security_group" "rds_security_group" {
  name        = "rds-high-availability"
  description = "Security group para RDS Multi-AZ"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

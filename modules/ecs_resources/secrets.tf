

resource "aws_secretsmanager_secret" "db_secret" {
  name        = "my-rds-secret-${var.tag_value}"
  description = "Secret for RDS MySQL credentials"

  tags = {
    Name = "RDS MySQL Secret"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    endpoint = aws_db_instance.mysql_db.endpoint #equivalente a host
    name = aws_db_instance.mysql_db.db_name

  })
}

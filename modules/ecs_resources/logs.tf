resource "aws_cloudwatch_log_group" "wp_task_log_group" {
  name = "/${var.tag_value}/ecs/wp-task-logs"
  retention_in_days = 7  # Opcional: define la retención de logs
}

resource "aws_cloudwatch_log_group" "flask_task_log_group" {
  name = "/${var.tag_value}/ecs/flask-task-logs"
  retention_in_days = 7  # Opcional: define la retención de logs
}
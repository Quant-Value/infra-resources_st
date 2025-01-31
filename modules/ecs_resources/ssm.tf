

#----------------------------- SSM ---------

resource "aws_ssm_parameter" "container_image_flask" {
  name  = "/${var.tag_value}/image/flask"
  type  = "SecureString"  # Usamos String si no necesitamos cifrado, o "SecureString" si lo deseas cifrado.
  value = var.custom_flask
}

resource "aws_ssm_parameter" "container_image_nginx" {
  name  = "/${var.tag_value}/image/nginx"
  type  = "SecureString"  # Usamos String si no necesitamos cifrado, o "SecureString" si lo deseas cifrado.
  value = var.custom_nginx
}

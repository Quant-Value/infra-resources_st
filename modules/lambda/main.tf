
/*
resource "aws_s3_bucket" "bucket" {
    bucket = "campus-dual-grupo4-terraform-state-backend"
    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
    object_lock_configuration {
        object_lock_enabled = "Enabled"
    }
    tags = {
        Name = "S3 Remote Terraform State Store for grup 4"
    }
}*/

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_lambda_function" "lambda" {
  function_name = "stb-practica_recursos-3"
  role          = aws_iam_role.iam_for_lambda.arn
  s3_bucket     = aws_s3_bucket.bucket.bucket # Referencia al nombre del bucket
  s3_key        = "requirements.txt"
  runtime       = "nodejs14.x"
  handler       = "index.handler"

  depends_on = [aws_s3_bucket.bucket]  # Asegura que el Bucket se cree antes de la función Lambda
}
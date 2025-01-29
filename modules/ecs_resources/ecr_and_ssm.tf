resource "aws_ecr_repository" "my_ecr_repo" {
name = "${var.tag_value}-my-ecr-repo"
image_tag_mutability = "MUTABLE"
image_scanning_configuration {
scan_on_push = true
}
}
/*
output "repository_url" { 
    value = aws_ecr_repository.my_ecr_repo.repository_url 
}*/

data "aws_iam_policy_document" "example" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "example" {
  repository = aws_ecr_repository.my_ecr_repo.name
  policy     = data.aws_iam_policy_document.example.json
}

resource "aws_ecr_lifecycle_policy" "my_lifecycle_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name

  policy = jsonencode({
    rules=[
        {
            rulePriority = 1
            description  = "Retain images for 30 days"
            #description="Retain images for 30 days and remove older images to manage space efficiently and ensure repository remains within storage limits"
            selection = {
                tagStatus  = "any"
                countType  = "sinceImagePushed"
                #countType = "imageCountMoreThan"
                countUnit = "days"
                countNumber= 50
            }
            action = {
                type = "expire"
            }
        }
    ]
    
  })
}

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

provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="stb"
  aws_region = "eu-west-2" 

}

terraform {
  backend "s3" {
    bucket = "proyect-2-stb-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/ecr/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}


resource "aws_ecr_repository" "my_ecr_repo" {
name = "${local.tag_value}-my-ecr-repo"
image_tag_mutability = "MUTABLE"
image_scanning_configuration {
scan_on_push = true
}
}

output "repository_url" { 
    value = aws_ecr_repository.my_ecr_repo.repository_url 
}

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


# Asignación de valores a las variables

aws_region    = "eu-west-3"                             # Región (puede ser configurada también en variables.tf si es fija)
bucket_name   = "proyect-1-stb-devops-bucket-terraform" # Nombre del bucket S3 (asegúrate de que sea único)
ami_id        = "ami-0574a94188d1b84a1"                 # Aquí pones la AMI de Red Hat para la región eu-west-3
instance_type = "c5.large"                              # Tipo de instancia, si deseas cambiarlo
acl           =  "public-read"
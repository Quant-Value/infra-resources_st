module "bucket_s3" {
  source      = "../modules/bucket_s3"
  aws_region  = var.aws_region    # Pasa la variable aws_region
  bucket_name = var.bucket_name   # Pasa la variable bucket_name
}

module "ec2_redhat" {
  source       = "../modules/ec2_redhat"
  aws_region   = var.aws_region   # Pasa la variable aws_region
  instance_type = var.instance_type # Pasa la variable instance_type
  ami_id        = var.ami_id       # Pasa la variable ami_id
}


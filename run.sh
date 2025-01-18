cd terraform
terraform init 
terraform plan -var-file=custom-vars.tfvars
terraform apply -auto-approve -var-file=custom-vars.tfvars


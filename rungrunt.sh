cd terragrunt/wordpress
terragrunt run-all init 
terragrunt run-all plan
terragrunt run-all apply -auto-approve


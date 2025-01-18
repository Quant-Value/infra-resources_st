locals{
    enviroment= "prod"
    common_vars= read_terragrunt_config(find_in_parent_folders("common.hcl"))
    common_vars_all=read_terragrunt_config(find_in_parent_folders("all-common.hcl"))
}
include {
    path = find_in_parent_folders("root.hcl")
    expose=true
}
terraform {
    #source="./"
    source=local.common_vars.inputs.module_path_to_import
}
#inputs = #merge(local.common_vars.inputs)
inputs={
  instance_type = local.common_vars.inputs.instance_type # Pasa la variable instance_type
  ami_id        = local.common_vars.inputs.ami_id       # Pasa la variable ami_id
  private_key_path=local.common_vars_all.inputs.private_key_path
  tag_value = join("", [local.common_vars_all.inputs.tag_value, local.enviroment])
  public_key_path=local.common_vars_all.inputs.public_key_path
  aws_region= local.common_vars.inputs.aws_region
  #module_path=join("",["../../",local.common_vars.inputs.module_path])
  module_path=local.common_vars.inputs.module_path
  #backend_bucket_name = local.common_vars.inputs.backend_bucket_name
  replicas=local.common_vars.inputs.replicas
  db_username=local.common_vars.inputs.db_username
  db_password=local.common_vars.inputs.db_password
}
  #backend_bucket_name = local.backend_bucket_name
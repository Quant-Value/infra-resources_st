locals{
    enviroment= "prod"
    aws_region = "eu-west-3"
    backend_bucket_name= "proyect-1-stb-devops-bucket"
    tag_value="stb"
    instance_type = "t2.micro" 
    ami_id= "ami-07db896e164bc4476"
    private_key_path = "~/.ssh/id_rsa"
    public_key_path = "~/.ssh/id_rsa.pub" 
}



terraform {
    #source="./"
    source="../../../modules/wordpress"

}
inputs = {
  instance_type = local.instance_type # Pasa la variable instance_type
  ami_id        = local.ami_id       # Pasa la variable ami_id
  private_key_path=local.private_key_path
  tag_value = join("-", [local.tag_value, local.enviroment])
  public_key_path=local.public_key_path
  aws_region= local.aws_region
  #backend_bucket_name = local.backend_bucket_name

}
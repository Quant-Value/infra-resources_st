inputs = {
    aws_region = "eu-west-3"
    tag_value="stb"
    instance_type = "t2.micro" 
    ami_id= "ami-07db896e164bc4476"
    private_key_path = "~/.ssh/id_rsa"
    public_key_path = "~/.ssh/id_rsa.pub" 
    module_path="../../../modules/wordpress"
    backend_bucket_name= "proyect-1-stb-devops-bucket"
}
    #backend_bucket_name= "proyect-1-stb-devops-bucket"
# Crear un Key Pair para EC2
provider "aws" {
  region = var.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf
  #profile = "default"
  #quitar profile si se compila desde la nube
}


resource "aws_key_pair" "key" {
  key_name   = "my-key-name-${var.tag_value}"
  public_key = file(var.public_key_path)  # Ruta de tu clave pública en tu máquina local
}

# Obtener la VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Obtener las zonas de disponibilidad disponibles
data "aws_availability_zones" "available" {
  state = "available"
}

# Paso 2: Listar todas las subredes de la VPC
data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Paso 3: Guardar la primera subred de la lista en el índice 0
locals {
  first_subnet_id = length(data.aws_subnets.vpc_subnets.ids) > 0 ? data.aws_subnets.vpc_subnets.ids[0] : null
}
/*
#----------------------------------------------------   calcular subnet en base a otras existentes en la misma vpc ---------------------------------
# Obtener las subredes existentes en la VPC por defecto usando un filtro
data "aws_subnets" "existing_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Obtener detalles de cada subred existente
data "aws_subnet" "existing_subnet_details" {
  for_each = toset(data.aws_subnets.existing_subnets.ids)

  id = each.value
}

output "existing_cidrs_output" {
  value = [for subnet in data.aws_subnet.existing_subnet_details : subnet.cidr_block]
}

# Almacenar el valor del comando adecuado en un local
locals {
  #os_target = data.external.os_info.result == "Windows" ? "py" : "python3"
  os_target ="python3" 
}


# Llamar al script Python para obtener el siguiente bloque CIDR disponible
data "external" "next_subnet" {
  #program = [local.os_target, "${path.module}/calculate_next_subnet.py"]
  program = [local.os_target, "${path.module}/calculate_next_subnet.py"]

  # Pasar los CIDRs de las subredes existentes y el CIDR base
  query = {
    existing_cidrs = jsonencode([for subnet in data.aws_subnet.existing_subnet_details : subnet.cidr_block]),
    base_cidr      = data.aws_vpc.default.cidr_block
  }
}

# Obtener las subredes existentes en la VPC por nombre de tag
data "aws_subnets" "exist_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "tag:Name"
    values = ["Subnet-4-${var.tag_value}"]  # Buscar subred por nombre de tag
  }
}
# Obtener los detalles de cada subred existente (como el CIDR)
data "aws_subnet" "exist_subnet_details" {
  for_each = toset(data.aws_subnets.exist_subnet.ids)

  id = each.value
}

# Verificar si la subred con el nombre "NextSubnet-stb" ya existe
locals {
  subnet_exists = length(data.aws_subnets.exist_subnet.ids) > 0
}

# Usar el bloque CIDR calculado por el script en la creación de la subred
resource "aws_subnet" "next_subnet" {
  #count = local.subnet_exists ? 0: 1
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = local.subnet_exists? values(data.aws_subnet.exist_subnet_details)[0].cidr_block : data.external.next_subnet.result["next_subnet"]  # Usar el resultado del script Python
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-4-${var.tag_value}"
  }
}*/

/*output "subnet_cidr" {
  value = local.subnet_exists ? data.aws_subnets.exist_subnet.cidr_block: aws_subnet.next_subnet[0].cidr_block
}*/

# --------------------------------------------------------------------------------------------------------------------------------------------------------------
# Crear un Security Group para EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.tag_value}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  # Reglas de entrada para EC2
  ingress {
    from_port   = 22   # Permitir SSH para acceso a la EC2
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # O reemplaza con una IP específica si prefieres restringir el acceso
  }

  ingress {
    from_port   = 80   # Permitir HTTP (NGINX)
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Acceso desde cualquier IP
  }
  ingress {
    from_port   = 8080   # Permitir HTTP (NGINX)
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Acceso desde cualquier IP
  }

  # Reglas de salida para permitir todo el tráfico
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Todo el tráfico
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-${var.tag_value}"
  }
}

# Crear un Security Group para MySQL (RDS)
resource "aws_security_group" "rds_sg" {
  name        = "${var.tag_value}-rds-sg"
  description = "Security group for MySQL RDS"
  vpc_id      = data.aws_vpc.default.id

  # Reglas de entrada para MySQL (RDS)
  ingress {
    from_port   = 3306  # Puerto por defecto de MySQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]  # Solo permitir la red interna de la VPC
  }
  ingress{
    from_port   = 3306  # Puerto por defecto de MySQL
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = {
    Name = "rds-sg-${var.tag_value}"
  }
}

# Output para el Security Group de EC2
output "ec2_security_group_info" {
  value = {
    sg_id        = aws_security_group.ec2_sg.id
    vpc_id       = aws_security_group.ec2_sg.vpc_id
    sg_name      = aws_security_group.ec2_sg.name
  }
}

# Output para el Security Group de RDS
output "rds_security_group_info" {
  value = {
    sg_id        = aws_security_group.rds_sg.id
    vpc_id       = aws_security_group.rds_sg.vpc_id
    sg_name      = aws_security_group.rds_sg.name
  }
}




# Crear una instancia EC2 con un bloque de provisionamiento SSH
resource "aws_instance" "my_instance" {
  ami             = var.ami_id  # Reemplaza con una AMI válida para tu región (Ubuntu, RedHat, etc.)
  instance_type   = var.instance_type
  key_name        = aws_key_pair.key.key_name
  #subnet_id       = local.subnet_exists ? values(data.aws_subnet.exist_subnet_details)[0].id : aws_subnet.next_subnet.id
  subnet_id = local.first_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true  # Si necesitas acceso público
  disable_api_termination = false
  
  # Configuración de provisioners
  provisioner "remote-exec" {# este bloque es para que si ejecuto un local-exec sobre este ec2 espere a que la maquina este accesible.
    inline = ["echo Hey system"]
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Usa "ec2-user" para AMIs de Amazon Linux, "ubuntu" para AMIs de Ubuntu
      private_key = file(var.private_key_path)  # Ruta a tu clave privada en tu máquina local
      host        = self.public_ip  # La IP pública de la instancia
    }

  }
  provisioner "local-exec"{
    command = "echo algos es añsldkjf"#ejecutar ansible desde aqui
  }
  

  tags = {
    Name = "Wordpress-${var.tag_value}"
  }
  depends_on = [        # Esperar a que la subred se cree
    aws_security_group.ec2_sg      # Esperar a que el Security Group EC2 se cree
  ]
}

# Crear una base de datos MySQL usando Amazon RDS
resource "aws_db_instance" "mysql_db" {
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  identifier        = "mymysqldb${var.tag_value}"
  engine            = "mysql"
  instance_class    = "db.t3.micro"  # Clase de instancia para MySQL
  allocated_storage = 10  # Almacenamiento en GB
  db_name           = "mydatabase${var.tag_value}"
  username          = "admin"
  password          = "mypassword123"  # Asegúrate de usar contraseñas seguras
  skip_final_snapshot = true
  publicly_accessible = true
  multi_az          = false
  storage_type      = "gp2"
  #b_subnet_group

  tags = {
    Name = "MySQLDatabase-${var.tag_value}"
  }
  depends_on = [
    aws_security_group.rds_sg        # Esperar a que el Security Group RDS se cree
  ]
}

resource "null_resource" "update_hosts_ini1" {
  provisioner "local-exec" {
    #command = "pwd"

    command = "echo [webservers] > ${var.module_path}ansible/hosts.ini"
     }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
  depends_on = [aws_instance.my_instance]
}

resource "null_resource" "update_hosts_ini2" {
  provisioner "local-exec" {

    command = "echo ${aws_instance.my_instance.public_ip}  ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa >> ${var.module_path}ansible/hosts.ini"

  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
  depends_on = [aws_instance.my_instance,null_resource.update_hosts_ini1]
}


resource "null_resource" "update_rdsvars_ini1" {
  provisioner "local-exec" {

    command = "echo rds_username: ${aws_db_instance.mysql_db.username}   > ${var.module_path}ansible/vars.yml"

  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
}
resource "null_resource" "update_rdsvars_ini2" {
  provisioner "local-exec" {

    command = "echo rds_password: ${aws_db_instance.mysql_db.password}   >> ${var.module_path}ansible/vars.yml"

  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
  depends_on = [aws_instance.my_instance,null_resource.update_rdsvars_ini1]
}

resource "null_resource" "update_rdsvars_ini3" {
  provisioner "local-exec" {

    command = "echo rds_endpoint: ${aws_db_instance.mysql_db.endpoint}   >> ${var.module_path}ansible/vars.yml"

  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
  depends_on = [aws_instance.my_instance,null_resource.update_rdsvars_ini2]
}

resource "null_resource" "update_rdsvars_ini4" {
  provisioner "local-exec" {

    command = "echo rds_db_name: ${aws_db_instance.mysql_db.db_name}   >> ${var.module_path}ansible/vars.yml"
  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
  depends_on = [aws_instance.my_instance,null_resource.update_rdsvars_ini3]
}
resource "null_resource" "provisioner1" {
  provisioner "local-exec" {

    command = "export ANSIBLE_CONFIG=${var.module_path}ansible/ansible.cfg && ansible-playbook -i ${var.module_path}ansible/hosts.ini ${var.module_path}ansible/install1.yml"
  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
  depends_on = [aws_instance.my_instance,null_resource.update_rdsvars_ini4,null_resource.update_hosts_ini2]
}
resource "null_resource" "provisioner2" {
  provisioner "local-exec" {

    command = "export ANSIBLE_CONFIG=${var.module_path}ansible/ansible.cfg && ansible-playbook -i ${var.module_path}ansible/hosts.ini ${var.module_path}ansible/php_config.yml"
  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  
  depends_on = [null_resource.provisioner1]
}
/*
terraform {
  backend "s3" {
    bucket = var.backend_bucket_name          # Nombre de tu bucket S3
    key    = "state/${var.tag_value}/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = var.aws_region                          # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}*/


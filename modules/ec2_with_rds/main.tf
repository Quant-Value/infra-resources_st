# Crear un Key Pair para EC2
resource "aws_key_pair" "key" {
  key_name   = "my-key-name-stb"
  public_key = file("~/.ssh/id_rsa.pub")  # Ruta de tu clave pública en tu máquina local
}

# Crear una instancia EC2 con un bloque de provisionamiento SSH
resource "aws_instance" "my_instance" {
  ami             = var.ami_id  # Reemplaza con una AMI válida para tu región (Ubuntu, RedHat, etc.)
  instance_type   = var.instance_type
  key_name        = aws_key_pair.key.key_name
  #security_groups = [aws_security_group.ec2_sg.name]
  associate_public_ip_address = true  # Si necesitas acceso público
  
  # Configuración de provisioners
  provisioner "remote-exec" {
    inline = [
      "echo 'Instalando NGINX y MySQL Server'",
      "sudo apt update -y",
      "sudo apt install -y nginx mysql-server"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Usa "ec2-user" para AMIs de Amazon Linux, "ubuntu" para AMIs de Ubuntu
      private_key = file(var.private_key_path)  # Ruta a tu clave privada en tu máquina local
      host        = self.public_ip  # La IP pública de la instancia
    }
  }

  tags = {
    Name = "EC2Instance-stb"
  }
}

# Crear una base de datos MySQL usando Amazon RDS
resource "aws_db_instance" "mysql_db" {
  identifier        = "my-mysql-db-stb"
  engine            = "mysql"
  instance_class    = "db.t2.micro"  # Clase de instancia para MySQL
  allocated_storage = 20  # Almacenamiento en GB
  db_name           = "mydatabase-stb"
  username          = "admin"
  password          = "mypassword123"  # Asegúrate de usar contraseñas seguras
  skip_final_snapshot = true
  publicly_accessible = true
  multi_az          = false
  storage_type      = "gp2"

  tags = {
    Name = "MySQLDatabase"
  }
}

# Output para mostrar la IP pública de la instancia EC2 y el endpoint de la base de datos MySQL
output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}
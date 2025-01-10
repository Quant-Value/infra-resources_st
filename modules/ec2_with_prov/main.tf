resource "aws_key_pair" "key" {
  key_name   = "my-key-name-stb"
  public_key = file("~/.ssh/id_rsa.pub")  # Ruta al archivo público de la clave SSH en tu máquina
}

/*
resource "aws_security_group" "sg" {
  name        = "my-security-group-stb"
  description = "Allow SSH and HTTP access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}*/
#al usar la vpc por defecto no se necesita crear los demas componenetes de red
resource "aws_instance" "ubuntu_instance" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  #security_groups   = [aws_security_group.sg.name]
  key_name          = aws_key_pair.key.key_name  # Nombre del Key Pair
  associate_public_ip_address = true  # Si quieres acceso público

  tags = {
    Name = "MyUbuntu-stb"
  }
/*
  provisioner "file" {
    source      = "../algo.txt"
    destination = "/tmp/alago.txt"

    connection {
      type        = "ssh"
      user        = "ec2-user"  # Para una AMI Red Hat, usa 'ec2-user'
      private_key = file(var.private_key_path)  # Ruta al archivo .pem de la key pair
      host        = self.public_ip  # Usa la IP pública de la instancia
    }
  }*/
  /*
  provisioner "remote-exec"{
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Para una AMI Red Hat, usa 'ec2-user'
      private_key = file(var.private_key_path)  # Ruta al archivo .pem de la key pair
      host        = self.public_ip  # Usa la IP pública de la instancia
    }
    inline = [
      # Actualizar el sistema
      "sudo apt-get update -y",
      
      # Instalar NGINX
      "sudo apt-get install -y nginx",
      
      # Iniciar y habilitar NGINX
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",

      # Configuración adicional (opcional)
      # Puedes agregar configuraciones de NGINX si es necesario aquí, por ejemplo:
      #"echo 'Hello, NGINX!' | sudo tee /var/www/html/index.html"
    ]
  }*/
}

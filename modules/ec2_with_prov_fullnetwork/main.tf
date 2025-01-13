
# Crear un par de claves
resource "aws_key_pair" "key" {
  key_name   = "my-key-name-stb"
  public_key = file("~/.ssh/id_rsa.pub")  # Ruta al archivo público de la clave SSH en tu máquina
}

# Crear una VPC
resource "aws_vpc" "main" {
  cidr_block = "10.14.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc-stb"
  }
}

# Crear una subred pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.14.1.0/24"
  availability_zone       = "eu-west-3a"  # Cambia la zona de disponibilidad según tu región
  map_public_ip_on_launch = true

  tags = {
    Name = "my-public-subnet-stb"
  }
}

# Crear una Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw-stb"
  }
}

# Crear una tabla de enrutamiento para la subred pública
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "my-public-route-table-stb"
  }
}

# Asociar la tabla de enrutamiento con la subred pública
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route_table.id
}

# Crear un grupo de seguridad
resource "aws_security_group" "sg" {
  name        = "my-security-group-stb"
  description = "Allow SSH and HTTP access"
  vpc_id= aws_vpc.main.id
  
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group-stb"
  }
}

# Crear la instancia EC2 en la VPC
resource "aws_instance" "ubuntu_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name  # Nombre del Key Pair
  subnet_id              = aws_subnet.public.id
  security_groups         = [aws_security_group.sg.id]
  associate_public_ip_address = true  # Asigna una IP pública

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
  }
  */
}

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

#Paso 2.1: Listar zonas de disponibilidad
data "aws_availability_zones" "available" {}

#Paso 3: Crear siempre 1 subredes por cada az
resource "aws_subnet" "subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = element(["172.31.103.0/24", "172.31.104.0/24", "172.31.105.0/24"], count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-${var.tag_value}-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

# Local para almacenar las subredes creadas
locals {
  all_subnet_ids = aws_subnet.subnet[*].id  # Lista de IDs de subredes creadas
}



resource "aws_eks_cluster" "cluster_1" {
  name = "${var.tag_value}-cluster1"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = local.all_subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster_role" {
  name = "eks-cluster-example-${var.tag_value}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect   = "Allow"
        Sid      = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_security_group" "node_sg" {
  name        = "node-sg-${var.tag_value}"
  description = "Security group for Load Balancer"
  vpc_id      = data.aws_vpc.default.id

  // Permitir tráfico HTTP en el puerto 80 (entrada de los clientes)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acceso público desde cualquier lugar
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acceso público desde cualquier lugar
  }


  // Permitir todo el tráfico de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node-sg-${var.tag_value}"
  }
}

resource "aws_eks_node_group" "basic_group" {
  cluster_name    = aws_eks_cluster.cluster_1.name
  node_group_name = "${var.tag_value}-group-node"
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = local.all_subnet_ids
  scaling_config {
    desired_size=1
    max_size=2
    min_size=1
  }
  instance_types= [var.instance_type]

  remote_access{
    ec2_ssh_key = aws_key_pair.key.key_name
    source_security_group_ids= [aws_security_group.node_sg.id]
  }
}
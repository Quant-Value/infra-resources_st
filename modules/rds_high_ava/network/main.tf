data "aws_availability_zones" "available" {
  state = "available"
}

# Crear la VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "stb-vpc"
  }

}

# Crear subredes dinámicamente en cada zona de disponibilidad  -> genera tantas subredes como zonas de disponibilidad exista en la region
resource "aws_subnet" "private_subnets" {
  for_each = toset(data.aws_availability_zones.available.names)

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 12, index(data.aws_availability_zones.available.names, each.key))#he pueso 13 para generar subredes con mascara /28 (16 ips disponibles), por defecto estaba 8 que generaba mascaras /24
  availability_zone = each.key
  map_public_ip_on_launch = false
  tags = {
    Name = "stb-subnet-${each.key}-private"
  }
}
/*
# Crear subredes dinámicamente dependiendo de si hay réplicas o no
resource "aws_subnet" "private_subnets" {
  # Si no hay réplicas, solo se crea 1 subred en la primera zona de disponibilidad.
  # Si hay réplicas, se crean `n + 1` subredes donde `n` es el número de réplicas.
  for_each = var.create_replica ? 
            flatten([data.aws_availability_zones.available.names, [for i in range(var.rds_replicas) : "replica-${i}"]]) :
            [data.aws_availability_zones.available.names[0]]  # Solo una subred si no hay réplicas

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 14, index(each.value, 0))  # Genera subredes con máscara /30
  availability_zone = each.value
  map_public_ip_on_launch = false
}*/
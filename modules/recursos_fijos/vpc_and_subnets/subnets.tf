locals {
  subnet_cidr_blocks_public = [
    "10.19.0.0/23",  # CIDR para la subnet A
    "10.19.2.0/23",  # CIDR para la subnet B
    "10.19.4.0/23"   # CIDR para la subnet C
  ]
  subnet_cidr_blocks_private = [
    "10.19.6.0/23",  # CIDR para la subnet A
    "10.19.8.0/23",  # CIDR para la subnet B
    "10.19.10.0/23"   # CIDR para la subnet C
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Crear las subnets a partir de la lista de CIDR blocks y zonas de disponibilidad
resource "aws_subnet" "subnets_public" {
  for_each = toset(local.subnet_cidr_blocks_public)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = element(data.aws_availability_zones.available.names, index(local.subnet_cidr_blocks_public, each.value))
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.tag_value}-public-subnet-${each.key}"
  }
}

# Crear las subnets a partir de la lista de CIDR blocks y zonas de disponibilidad
resource "aws_subnet" "subnets_private" {
  for_each = toset(local.subnet_cidr_blocks_private)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = element(data.aws_availability_zones.available.names, index(local.subnet_cidr_blocks_private, each.value))
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.tag_value}-private-subnet-${each.key}"
  }
}

# Bloque de output para exponer la lista de subnets
output "subnets_public_info" {
  value = {
    for subnet in aws_subnet.subnets_public : subnet.id => {
      id = subnet.id
      cidr = subnet.cidr_block
      
    }
  }
  description = "A map of public subnet IDs to their CIDR blocks."
}
output "subnets_private_info" {
  value = {
    for subnet in aws_subnet.subnets_private : subnet.id => {
      id = subnet.id
      cidr = subnet.cidr_block
      
    }
  }
  description = "A map of public subnet IDs to their CIDR blocks."
}
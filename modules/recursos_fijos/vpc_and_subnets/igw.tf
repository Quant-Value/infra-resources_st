# Crear un Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "stb-igw"
  }
}

# Crear una tabla de rutas para las subnets públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.tag_value}-public-route-table"
  }
}

# Asociar la tabla de rutas con las subnets públicas
resource "aws_route_table_association" "public_subnet_association" {
  for_each = aws_subnet.subnets_public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
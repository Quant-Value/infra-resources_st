# Obtener la VPC por defecto
data "aws_vpc" "default" {
  default = true
}
data "aws_availability_zones" "available" {
  state = "available"
}
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
# Configuración del proveedor external
provider "external" {}
/*
# Obtener el tipo de sistema operativo
data "external" "os_info" {
  program = ["powershell", "-Command", "if ($IsWindows) { Write-Output 'Windows' } else { Write-Output 'Linux' }"]
}
*/
# Almacenar el valor del comando adecuado en un local
locals {
  #os_target = data.external.os_info.result == "Windows" ? "py" : "python3"
  os_target ="py" 
}


# Llamar al script Python para obtener el siguiente bloque CIDR disponible
data "external" "next_subnet" {
  program = [local.os_target, "${path.module}/calculate_next_subnet.py"]

  # Pasar los CIDRs de las subredes existentes y el CIDR base
  query = {
    existing_cidrs = jsonencode([for subnet in data.aws_subnet.existing_subnet_details : subnet.cidr_block]),
    base_cidr      = data.aws_vpc.default.cidr_block
  }
}


# Usar el bloque CIDR calculado por el script en la creación de la subred
resource "aws_subnet" "next_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = data.external.next_subnet.result["next_subnet"]  # Usar el resultado del script Python
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "NextSubnet-stb"
  }
}

output "subnet_cidr" {
  value = aws_subnet.next_subnet.cidr_block
}

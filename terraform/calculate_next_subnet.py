import ipaddress
import sys
import json

def find_next_available_subnet(existing_cidrs, base_cidr):
    # Convertir la cadena JSON a lista
    existing_cidrs = json.loads(existing_cidrs)
    
    # Convertir CIDRs a objetos de red
    existing_networks = [ipaddress.IPv4Network(cidr) for cidr in existing_cidrs]

    # Definir la red base
    base_network = ipaddress.IPv4Network(base_cidr)
    all_subnets = list(base_network.subnets(new_prefix=20))

    # Filtrar los subnets ya ocupados
    available_subnets = [str(subnet) for subnet in all_subnets if subnet not in existing_networks]

    # Retornar el siguiente subnet disponible
    return available_subnets[0] if available_subnets else None

def main():
    # Leer los datos pasados por Terraform
    input_data = json.loads(sys.stdin.read())
    existing_cidrs = input_data['existing_cidrs']
    base_cidr = input_data['base_cidr']

    # Llamar a la función para obtener el siguiente subnet
    next_subnet = find_next_available_subnet(existing_cidrs, base_cidr)
    
    if next_subnet:
        print(json.dumps({"next_subnet": next_subnet}))
    else:
        print(json.dumps({"error": "No available subnets."}))

if __name__ == "__main__":
    main()

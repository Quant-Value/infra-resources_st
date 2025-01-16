# Infra Resources

Este repositorio contiene los recursos necesarios para la infraestructura base del proyecto. Aquí se definen las configuraciones y scripts necesarios para implementar y gestionar la infraestructura utilizando herramientas de Infraestructura como Código (IaC).

## Contenido
- **Arquitectura de red:** Configuración de subredes, grupos de seguridad y redes virtuales.
- **Servidores:** Definiciones para el aprovisionamiento de máquinas virtuales u otros servidores.
- **Automatización:** Scripts para configurar y desplegar la infraestructura.

## Uso
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/<user>/infra-resources.git




   terraform init
   terraform plan
   terraform apply -auto-approve
   terraform destroy -auto-approve


   terraform apply -auto-approve



ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@15.237.202.141 "ls /tmp"

ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@

terragrunt run-all init  && terragrunt run-all apply --terragrunt-non-interactive

terragrunt run-all destroy --terragrunt-non-interactive


export ANSIBLE_CONFIG=/mnt/e/Campusdual/repo-personal-campus/infra-resources/modules/wordpress/ansible/ansible.cfg

ansible-playbook -i hosts.ini install.yml 

terraform apply -replace="module.ec2_wordpress.aws_instance.my_instance" -auto-approve

/mnt/e/Campusdual/repo-personal-campus/infra-resources/terragrunt/wordpress/dev/.terragrunt-cache/tY2qJ7fWPxhHukQJvPgjK6wlHfI/G3NyCIgTl40a0GFpP2qOnR7j2Ug






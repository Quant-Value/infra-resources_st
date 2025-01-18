# Infra Resources

Este repositorio contiene los recursos necesarios para la infraestructura base del proyecto. Aquí se definen las configuraciones y scripts necesarios para implementar y gestionar la infraestructura utilizando herramientas de Infraestructura como Código (IaC).

Importante ( [] -> denota opcionalidad ) 

## Contenido
- **Arquitectura de red:** Configuración de subredes, grupos de seguridad y redes virtuales.
- **Servidores:** Definiciones para el aprovisionamiento de máquinas virtuales u otros servidores.
- **Automatización:** Scripts para configurar y desplegar la infraestructura.

## Uso
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/<user>/infra-resources.git
   ```
2. Configurar variables de cada usuario:
   2.1 modifica estos archivos ->terraform/backend.tf , terraform/custom-vars.tfvars and id_rsa.pub
   2.2 modifica estos archivos -> terragrunt/[modulo]/all-common.hcl
3. Haz uso de estos scripts para hacer todo mas sencillo:
   3.1 run.sh y rundel.sh
   3.2 rungrunt.sh y rundelgrunt.sh







ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@

terragrunt run-all init  && terragrunt run-all apply --terragrunt-non-interactive

terragrunt run-all destroy --terragrunt-non-interactive


export ANSIBLE_CONFIG=/mnt/e/Campusdual/repo-personal-campus/infra-resources/modules/wordpress/ansible/ansible.cfg

Please modified the terraform/backend.tf , terraform/custom-vars.tfvars and id_rsa.pub if you want to not destroy others infra

Use the scipts ( [] -> denotes optionallity ) run[del].sh and run[del]grunt.sh in order to make your life simply and check that you want to exect this script in the path desired.



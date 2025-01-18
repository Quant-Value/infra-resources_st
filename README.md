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
2. Configurar las variables del usuario

Antes de ejecutar los scripts, personaliza la configuración de tu infraestructura según tus necesidades. Para ello, modifica los siguientes archivos.

   2.1. Archivos clave para la configuración:

    terraform/backend.tf: Modifica este archivo para configurar un backend diferente para Terraform.
    terraform/custom-vars.tfvars: Personaliza las variables según tu entorno y requisitos específicos.
    id_rsa.pub: Asegúrate de modificar la clave pública para evitar sobrescribir las claves de otros usuarios o infraestructuras.

   2.2. Configuración de módulos Terragrunt:

    terragrunt/[modulo]/all-common.hcl: Personaliza este archivo para cada módulo de Terragrunt tu configuración de entorno.

3. Uso de scripts automatizados

Para simplificar la gestión de la infraestructura, puedes utilizar los siguientes scripts.
Scripts para ejecutar y eliminar recursos:


    run.sh: Este script ejecuta los recursos definidos desde terraform.
    rundel.sh: Este script elimina los recursos definidos desde terraform.
    rungrunt.sh: Este script ejecuta los recursos definidos desde terragrunt.
    rundelgrunt.sh: Este script elimina los recursos definidos desde terragrunt.








ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@

terragrunt run-all init  && terragrunt run-all apply --terragrunt-non-interactive

terragrunt run-all destroy --terragrunt-non-interactive


export ANSIBLE_CONFIG=/mnt/e/Campusdual/repo-personal-campus/infra-resources/modules/wordpress/ansible/ansible.cfg

Please modified the terraform/backend.tf , terraform/custom-vars.tfvars and id_rsa.pub if you want to not destroy others infra

Use the scipts ( [] -> denotes optionallity ) run[del].sh and run[del]grunt.sh in order to make your life simply and check that you want to exect this script in the path desired.



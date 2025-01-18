# Infra Resources

Este repositorio contiene los recursos necesarios para la infraestructura base del proyecto. Aquí se definen las configuraciones y scripts necesarios para implementar y gestionar la infraestructura utilizando herramientas de Infraestructura como Código (IaC).

Importante ( [] -> denota opcionalidad ) 

## Contenido
- **Arquitectura de red:** Configuración de subredes, grupos de seguridad y redes virtuales.
- **Servidores:** Definiciones para el aprovisionamiento de máquinas virtuales u otros servidores.
- **Automatización:** Scripts para configurar y desplegar la infraestructura.

## Uso
### 1. Clonar el repositorio:
   ```bash
   git clone https://github.com/<user>/infra-resources.git
   ```
### 2. Configurar las variables del usuario

Antes de ejecutar los scripts, personaliza la configuración de tu infraestructura según tus necesidades. Para ello, modifica los siguientes archivos.

#### 2.1. Archivos clave para la configuración:

    terraform/backend.tf: Modifica este archivo para configurar un backend diferente para Terraform.
    terraform/custom-vars.tfvars: Personaliza las variables según tu entorno y requisitos específicos.
    id_rsa.pub: Asegúrate de modificar la clave pública para evitar sobrescribir las claves de otros usuarios o infraestructuras.

#### 2.2. Configuración de módulos Terragrunt:

    terragrunt/[modulo]/all-common.hcl: Personaliza este archivo para cada módulo de Terragrunt tu configuración de entorno.

### 3. Uso de scripts automatizados

Para simplificar la gestión de la infraestructura, puedes utilizar los siguientes scripts.
Scripts para ejecutar y eliminar recursos:


    run.sh: Este script ejecuta los recursos definidos desde terraform.
    rundel.sh: Este script elimina los recursos definidos desde terraform.
    rungrunt.sh: Este script ejecuta los recursos definidos desde terragrunt.
    rundelgrunt.sh: Este script elimina los recursos definidos desde terragrunt.

### 4. Uso de Github Actions

Para comenzar con **Github Actions**, primero necesitas configurar el archivo `docs/users.json`. A continuación, te mostramos un ejemplo del formato correcto:

```json
"Myusuariodegithub": {
  "AWS_ACCESS_KEY_ID": "AWS_ACCESS_KEY_ID_Tunombre",
  "AWS_SECRET_ACCESS_KEY": "AWS_SECRET_ACCESS_KEY_Tunombre",
  "AWS_SESSION_TOKEN": "AWS_SESSION_TOKEN_Tunombre",
  "AWS_EC2_KEY": "AWS_EC2_KEY_Tunombre"
}
```

Pasos a seguir:

    Configura tu archivo users.json:
        Añade el bloque anterior a tu archivo docs/users.json.
        Reemplaza Myusuariodegithub con tu nombre de usuario de GitHub.
        Sustituye Tunombre con el nombre que prefieras.

    Sube el archivo a tu repositorio: 
         Una vez configurado correctamente el archivo users.json, realiza el commit y push de los cambios a tu repositorio en GitHub.

    Configura los secretos en tu repositorio:
        Dirígete a la pestaña de Settings en tu repositorio.
        En el menú lateral, selecciona Security y luego Secrets and variables.
        Haz clic en Actions para agregar los secretos necesarios (repository secrets).

    Agrega los siguientes secretos:
        AWS_ACCESS_KEY_ID_Tunombre: El valor debe ser tu AWS_ACCESS_KEY_ID de AWS.
        AWS_SECRET_ACCESS_KEY_Tunombre: El valor debe ser tu AWS_SECRET_ACCESS_KEY de AWS.
        AWS_SESSION_TOKEN_Tunombre: El valor debe ser tu AWS_SESSION_TOKEN de AWS.
        AWS_EC2_KEY_Tunombre: El valor debe ser el contenido de tu clave privada asociada a la clave pública con la que creas las instancias EC2.

    Nota: Asegúrate de que el secreto AWS_EC2_KEY_Tunombre contenga el valor de tu clave privada de EC2, ya que será necesario para crear y gestionar instancias EC2 desde GitHub Actions.




### 5. Commandos para recordar

ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@

terragrunt run-all init  && terragrunt run-all apply --terragrunt-non-interactive

terragrunt run-all destroy --terragrunt-non-interactive

export ANSIBLE_CONFIG=/mnt/e/Campusdual/repo-personal-campus/infra-resources/modules/wordpress/ansible/ansible.cfg



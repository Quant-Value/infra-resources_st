## Infra Resources

[![Hello World Workflow](https://github.com/Salvadortarrio/infra-resources/actions/workflows/hello_word.yml/badge.svg)](https://github.com/Salvadortarrio/infra-resources/actions/workflows/hello_word.yml)



Este repositorio contiene los recursos necesarios para la infraestructura base del proyecto. Aquí se definen las configuraciones y scripts necesarios para implementar y gestionar la infraestructura utilizando herramientas de Infraestructura como Código (IaC).

Importante ( [ ] -> denota opcionalidad ) 

## Contenido
- **Arquitectura de red:** Configuración de subredes, grupos de seguridad y redes virtuales.
- **Servidores:** Definiciones para el aprovisionamiento de máquinas virtuales u otros servidores.
- **Automatización:** Scripts para configurar y desplegar la infraestructura.

## Uso
### 1. Clonar el repositorio:
   ```bash
   git clone https://github.com/Salvadortarrio/infra-resources.git
   ```
### 2. Configurar las variables del usuario

Antes de ejecutar los scripts, personaliza la configuración de tu infraestructura según tus necesidades. Para ello, modifica los siguientes archivos.

>[!IMPORTANT]
>Los cambios que estas por realizar solo funcionaran en un repositorio donde subas cambios tu solo. De lo contrario le podrias cambiar las iniciales a un compañero en su infraestructura cuando haga pull del repositorio.

>[!IMPORTANT]
>Cuando hagamos el proyecto entre los 5 deberiamos usar unas iniciales en común para los 5 y una misma clave publica y privada que deberiamos compartir por algun sitio seguro.

### 2.1. Configuración de Módulos Terraform:

    Configurar el Backend de Terraform:
        Modifica el archivo terraform/backend.tf para ajustar la configuración del backend que deseas utilizar para tu infraestructura. Tambien cambia la variable key si usas el mismo codigo pero en distintas ramas como dev o prod para que guarde el tfstate en distintas localizaciones de tu s3.
    Personalización de Variables:
        Personaliza las variables en el archivo terraform/custom-vars.tfvars según tu entorno y requisitos específicos.
    Modificar la Clave Pública:
        Asegúrate de actualizar la clave pública en el archivo id_rsa.pub para evitar sobrescribir las claves de otros usuarios o infraestructuras.

### 2.2. Configuración de Módulos Terragrunt:

    Personalización por Módulo de Terragrunt:
        Personaliza el archivo terragrunt/[modulo]/all-common.hcl para definir la configuración específica de tu entorno para cada módulo de Terragrunt.

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

    1. Configura tu archivo users.json:
        Añade el bloque anterior a tu archivo docs/users.json.
        Reemplaza Myusuariodegithub con tu nombre de usuario de GitHub.
        Sustituye Tunombre con el nombre que prefieras.

    2. Sube el archivo a tu repositorio: 
         Una vez configurado correctamente el archivo users.json, realiza el commit y push de los 
         cambios a tu repositorio en GitHub.

    3. Configura los secretos en tu repositorio:
        Dirígete a la pestaña de Settings en tu repositorio.
        En el menú lateral, selecciona Security y luego Secrets and variables.
        Haz clic en Actions para agregar los secretos necesarios (repository secrets).

    4. Agrega los siguientes secretos:
        AWS_ACCESS_KEY_ID_Tunombre: El valor debe ser tu AWS_ACCESS_KEY_ID de AWS.
        AWS_SECRET_ACCESS_KEY_Tunombre: El valor debe ser tu AWS_SECRET_ACCESS_KEY de AWS.
        AWS_SESSION_TOKEN_Tunombre: El valor debe ser tu AWS_SESSION_TOKEN de AWS.
        AWS_EC2_KEY_Tunombre: El valor debe ser el contenido de tu clave privada asociada a la clave 
            pública con la que creas las instancias EC2.
            
    5. Ejecuta el workflow de forma manual desde la pestaña de Actions.

Nota: Asegúrate de que el secreto AWS_EC2_KEY_Tunombre contenga el valor de tu clave privada de 
    EC2, ya que será necesario para crear y gestionar instancias EC2 desde GitHub Actions.

>[!WARNING]
>Configura los pasos 2, 4 y 5 para que no existan problemas a la hora de desplegar infraestructura.


>[!NOTE]
>¿Por qué seguimos este flujo?

>En el contexto de este bootcamp, no se nos proporcionan herramientas adicionales para gestionar las claves privadas de manera individual. Por ello, he diseñado el flujo de trabajo en GitHub Actions de tal forma que, si todos hacemos push al mismo repositorio, se utilice la clave privada de quien realizó el push, en lugar de usar la clave de otro compañero. Esto es especialmente útil en escenarios donde, de ser necesario, cada uno podría tener claves de acceso diferentes.

>PD: En este bootcamp, todos compartimos las mismas claves de acceso a AWS, por lo que, en última instancia, la distinción no afecta demasiado al flujo de trabajo. A pesar de >esto, mantener la clave asociada a cada push es una práctica que podemos aplicar para asegurar la flexibilidad en escenarios más complejos.

### 5. Subnets por persona

Para no pisarnos el trabajo entre nosotros hemos decidido usar un rango de ips para las subnets y mascara. Iz al fichero docs/ips_subnets_reservadas.txt y vereis cuales son las que estan reservadas aunque no esten en uso. Si alguno de los que lee esto falta su nombre ahi que me avise (Salva) y pondremos ahi sus ips para sus subnets. Por ultimo esto debe ser modificado con vuestras ips en el fichero modules/wordpress/main.tf en el recurso subnet, variable cidr_block y dentro de la lista pondreis vuestras ips.

### 6. Commandos para recordar

ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@

terragrunt run-all init  && terragrunt run-all apply --terragrunt-non-interactive

terragrunt run-all destroy --terragrunt-non-interactive

export ANSIBLE_CONFIG=/mnt/e/Campusdual/repo-personal-campus/infra-resources/modules/wordpress/ansible/ansible.cfg

minikube service nginx-service --url   #expone la ip fuera de wsl.

#configurar provedor de kubernetes
aws eks --region eu-west-3 update-kubeconfig --name mi-cluster-stb

kubectl top pod

kubectl get pods -n kube-system | grep metrics-server

 kubectl logs metrics-server-54bf7cdd6-lgh9k -n kube-system

 kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

 kubectl get deployment metrics-server -n kube-system

kubectl api-versions | grep autoscaling

#autoscaling very usefull
https://www.loft.sh/blog/kubernetes-horizontal-pod-autoscaling
https://stackoverflow.com/questions/55578271/how-to-horizontal-autoscaler-a-kubernetes-deployment

kubectl get hpa

docker stop $(docker ps -q)

docker build --no-cache -t custom-nginx .
docker tag custom-nginx:latest saltardevops/images:custom-nginx
docker push saltardevops/images:custom-nginx

#ffmpeg
ffmpeg -i "Sesion 7 2901-20250130 0838-1.mp4" -ss 00:00:00 -t 06:00:00 -c:v copy -c:a copy Sesion7.mkv

#para configurar ecr con docker
aws ecr get-login-password --region <tu-region> | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<tu-region>.amazonaws.com
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 248189943700.dkr.ecr.eu-west-3.amazonaws.com

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 248189943700.dkr.ecr.eu-west-2.amazonaws.com

#build flask

docker build --no-cache -t custom-flask .
docker tag custom-flask:latest 248189943700.dkr.ecr.eu-west-3.amazonaws.com/stb-my-ecr-repo:custom-flask
docker push 248189943700.dkr.ecr.eu-west-3.amazonaws.com/stb-my-ecr-repo:custom-flask


#build nginx

docker build --no-cache -t custom-nginx .
docker tag custom-nginx:latest 248189943700.dkr.ecr.eu-west-3.amazonaws.com/stb-my-ecr-repo:custom-nginx
docker push 248189943700.dkr.ecr.eu-west-3.amazonaws.com/stb-my-ecr-repo:custom-nginx

docker build --no-cache -t custom-nginx .
docker tag custom-nginx:latest 248189943700.dkr.ecr.eu-west-2.amazonaws.com/stb-my-ecr-repo:custom-nginx
docker push 248189943700.dkr.ecr.eu-west-2.amazonaws.com/stb-my-ecr-repo:custom-nginx

#dia 31 chatbot

aws eks --region eu-west-2 update-kubeconfig --name mi-cluster-stb

docker build --no-cache -t chat-bot .
docker tag chat-bot:latest 248189943700.dkr.ecr.eu-west-2.amazonaws.com/stb-my-ecr-repo:chat-bot
docker push 248189943700.dkr.ecr.eu-west-2.amazonaws.com/stb-my-ecr-repo:chat-bot

#escalado con request
#estresor mejor hasta el momento

wrk -t8 -c8000 -d300s http://ecs-alb-stb-891752077.eu-west-3.elb.amazonaws.com/api

### 7. Beauty readme [docs](https://docs.github.com/es/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

### 8. Algunas guias
[Repositorio remoto de imagenes de docker](docs/remote-repository.md)



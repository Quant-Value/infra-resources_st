# Guía para Crear un Registro Local de Docker y Subir Imágenes

Esta guía te muestra cómo crear un **registro local de Docker** en tu máquina para almacenar imágenes Docker y cómo usarlas en un clúster de Kubernetes.

## 1. Crear un Registro Docker Local

### Paso 1: Ejecutar el Registro Docker

Primero, vamos a ejecutar el contenedor de Docker Registry en tu máquina local (o en un servidor privado). Ejecuta el siguiente comando:

```bash
docker run -d -p 5000:5000 --name registry registry:2

Explicación:

    docker run -d: Ejecuta el contenedor en segundo plano.
    -p 5000:5000: Mapea el puerto 5000 de tu máquina local al puerto 5000 del contenedor. Este es el puerto por defecto donde el registro escucha.
    --name registry: Nombra el contenedor como registry para facilitar la gestión.
    registry:2: Usa la imagen oficial del registro de Docker, versión 2.

Paso 2: Verificar que el Registro está Funcionando

Verifica que el contenedor del registro esté corriendo con el siguiente comando:

docker ps

Deberías ver una salida similar a esta:

CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                    NAMES
d5e4d9038bc3   registry:2     "/bin/registry serve …"   2 minutes ago   Up 2 minutes   0.0.0.0:5000->5000/tcp   registry

2. Subir Imágenes al Registro Local
Paso 1: Construir tu Imagen Docker

Construye la imagen que deseas subir al registro local. Si tienes un Dockerfile en el directorio actual, ejecuta:

docker build -t mi-nginx-personalizado .

Paso 2: Etiquetar la Imagen para el Registro Local

Antes de subir la imagen, debes etiquetarla con el nombre de tu registro local. Usa el siguiente comando para etiquetar la imagen:

docker tag mi-nginx-personalizado localhost:5000/mi-nginx-personalizado:latest

Explicación:

    mi-nginx-personalizado: Es el nombre de la imagen que has construido.
    localhost:5000/mi-nginx-personalizado:latest: Es el nombre del registro local, donde localhost:5000 es el puerto de tu máquina local y mi-nginx-personalizado:latest es el nombre de la imagen con su etiqueta.

Paso 3: Subir la Imagen al Registro Local

Sube la imagen al registro local usando el siguiente comando:

docker push localhost:5000/mi-nginx-personalizado:latest

Si todo va bien, deberías ver una salida similar a esta:

The push refers to repository [localhost:5000/mi-nginx-personalizado]
6c4c61b56b91: Pushed
latest: digest: sha256:6f3e9b2b47cbcb19f0638b6a0d7d9b0d4778e6fd6b742c9ffb88dd0bb0fc1d1f size: 2775

3. Usar la Imagen en Kubernetes
Paso 1: Verificar Acceso al Registro Local desde Kubernetes

Si estás trabajando con un clúster local de Kubernetes (como Minikube o Docker Desktop), puedes usar la imagen directamente desde el registro local. Para Minikube, puedes cargar la imagen directamente al clúster con:

minikube image load localhost:5000/mi-nginx-personalizado:latest

Paso 2: Desplegar la Imagen en Kubernetes

Usa la imagen en tu despliegue de Kubernetes. A continuación se muestra un ejemplo de archivo YAML para un despliegue de Nginx (nginx-deployment.yaml):

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: localhost:5000/mi-nginx-personalizado:latest
        ports:
        - containerPort: 80

Paso 3: Aplicar el Despliegue en Kubernetes

Usa el siguiente comando para aplicar el manifiesto YAML y crear el despliegue:

kubectl apply -f nginx-deployment.yaml

4. Exponer el Servicio en Kubernetes

Para exponer el servicio y hacer que tu aplicación sea accesible, puedes crear un archivo Service de Kubernetes. Aquí hay un ejemplo (nginx-service.yaml):

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort

Paso 1: Aplicar el Servicio

Aplica el servicio con el siguiente comando:

kubectl apply -f nginx-service.yaml

Paso 2: Acceder al Servicio

Para acceder al servicio en Minikube, usa el siguiente comando:

minikube service nginx-service --url

Si no usas Minikube, puedes obtener el NodePort de Kubernetes y acceder a la IP pública del nodo junto con el puerto correspondiente.
5. Detener y Eliminar el Registro Local

Si ya no necesitas el registro local, puedes detener y eliminar el contenedor de Docker con los siguientes comandos:

docker stop registry
docker rm registry

Si también deseas borrar las imágenes almacenadas en el registro local, puedes eliminar el volumen creado para el registro:

docker volume prune

Resumen

    Crear un registro local: Usa docker run -d -p 5000:5000 --name registry registry:2 para iniciar el contenedor del registro.
    Construir y etiquetar imágenes: Usa docker build y docker tag para crear y etiquetar las imágenes para el registro local.
    Subir imágenes al registro: Usa docker push localhost:5000/mi-nginx-personalizado:latest para cargar las imágenes al registro local.
    Usar la imagen en Kubernetes: Crea un despliegue en Kubernetes usando la imagen del registro local.
    Exponer el servicio: Usa un Service de Kubernetes para hacer que tu aplicación sea accesible.
    Eliminar el registro local: Detén y elimina el contenedor de Docker cuando ya no lo necesites.
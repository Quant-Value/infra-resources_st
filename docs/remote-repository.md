# Guía para Crear una Imagen Docker, Loguearte en Docker Hub y Subirla a un Repositorio

Esta guía te enseña cómo crear una imagen Docker desde un `Dockerfile`, cómo loguearte en Docker Hub y cómo subir esa imagen a un repositorio que hayas creado en Docker Hub.

## 1. Crear una Imagen Docker

### Paso 1: Crear un Dockerfile

El primer paso es crear un archivo `Dockerfile` que contenga las instrucciones para construir tu imagen. A continuación, te muestro un ejemplo básico para crear una imagen de un servidor Nginx personalizado.

1. Crea un archivo `Dockerfile` en el directorio de tu proyecto.
   
   ```Dockerfile
   # Usar la imagen oficial de Nginx
   FROM nginx:latest

   # Copiar los archivos estáticos de la página web personalizada
   COPY ./html /usr/share/nginx/html

   # Exponer el puerto 80 para la web
   EXPOSE 80

Explicación:

    FROM nginx:latest: Usa la imagen oficial de Nginx como base.
    COPY ./html /usr/share/nginx/html: Copia los archivos HTML (por ejemplo, index.html) desde el directorio local html a la carpeta de Nginx donde se sirven los archivos estáticos.
    EXPOSE 80: Expone el puerto 80 para que Nginx pueda servir contenido web.

Paso 2: Construir la Imagen Docker

Una vez que tengas el Dockerfile, puedes construir la imagen Docker usando el siguiente comando:

docker build -t mi-nginx-personalizado .

Explicación:

    -t mi-nginx-personalizado: Da un nombre a la imagen que estás construyendo.
    El punto . indica que el Dockerfile está en el directorio actual.

Esto creará una imagen Docker personalizada basada en Nginx con tu contenido estático.
2. Loguearte en Docker Hub
Paso 1: Crear una Cuenta en Docker Hub

Si no tienes una cuenta en Docker Hub, ve a Docker Hub y crea una cuenta gratuita.
Paso 2: Loguearte desde la Línea de Comandos

Una vez que hayas creado tu cuenta en Docker Hub, debes loguearte en tu cuenta desde la terminal con el siguiente comando:

docker login -u <nombre_usuario>

Te pedirá que ingreses tu nombre de usuario y contraseña de Docker Hub.

Ejemplo de salida:

Username: tu_usuario
Password: ********
Login Succeeded

3. Subir la Imagen a Docker Hub
Paso 1: Etiquetar la Imagen

Antes de subir la imagen a Docker Hub, debes etiquetarla con el nombre de tu repositorio en Docker Hub. Por ejemplo, si tu usuario de Docker Hub es tu_usuario y el repositorio que quieres crear es mi-nginx-personalizado, puedes etiquetar la imagen con:

docker tag mi-nginx-personalizado tu_usuario/mi-nginx-personalizado:latest

Explicación:

    mi-nginx-personalizado: El nombre de la imagen que has construido localmente.
    tu_usuario/mi-nginx-personalizado:latest: El nombre del repositorio en Docker Hub y la etiqueta (en este caso, latest).

Paso 2: Subir la Imagen a Docker Hub

Una vez que hayas etiquetado la imagen correctamente, puedes subirla a Docker Hub con el siguiente comando:

docker push tu_usuario/mi-nginx-personalizado:latest

Explicación:

    Este comando empujará la imagen a Docker Hub bajo tu usuario (tu_usuario), en el repositorio llamado mi-nginx-personalizado.

Durante el proceso de docker push, verás algo similar a esto:

The push refers to repository [docker.io/tu_usuario/mi-nginx-personalizado]
f3d27bcf76d8: Pushed
latest: digest: sha256:4b4417a3f89cd220f020cabc9c5f5776b60391d85f582dcb2d5188aeb9b3b58c size: 549

Una vez completado, tu imagen estará disponible en tu repositorio de Docker Hub.
4. Verificar que la Imagen ha Sido Subida

Para verificar que tu imagen ha sido subida correctamente, puedes ir al repositorio de Docker Hub y buscar tu_usuario/mi-nginx-personalizado. Ahí podrás ver las versiones disponibles de la imagen que subiste.
5. Descargar y Usar la Imagen desde Docker Hub
Paso 1: Descargar la Imagen

Si deseas usar la imagen desde otro sistema o máquina, puedes descargarla con el siguiente comando:

docker pull tu_usuario/mi-nginx-personalizado:latest

Paso 2: Correr el Contenedor con la Imagen

Después de descargarla, puedes correr el contenedor utilizando la imagen de Docker que subiste:

docker run -d -p 8080:80 tu_usuario/mi-nginx-personalizado:latest

Esto ejecutará el contenedor en segundo plano, mapeando el puerto 80 del contenedor al puerto 8080 en tu máquina local. Puedes acceder a la aplicación web desde http://localhost:8080.
6. Resumen

    Construir la Imagen: Usa docker build para crear una imagen desde un Dockerfile.
    Loguearte en Docker Hub: Usa docker login para autenticarte en tu cuenta de Docker Hub.
    Subir la Imagen a Docker Hub: Usa docker tag y docker push para subir la imagen al repositorio de Docker Hub.
    Verificar la Subida: Comprueba el repositorio en Docker Hub para asegurarte de que la imagen está disponible.
    Descargar y Usar la Imagen: Usa docker pull y docker run para ejecutar la imagen desde Docker Hub en otro sistema.

Ahora puedes crear, subir y usar imágenes Docker fácilmente. ¡Buena suerte con tus proyectos!


---

Este archivo `.md` cubre todo el proceso para crear una imagen Docker, loguearse en Docker Hub 
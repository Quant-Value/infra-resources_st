# Usar la imagen oficial de Nginx como base
FROM nginx:latest

# Copiar tu archivo HTML personalizado al contenedor
COPY index.html /usr/share/nginx/html/index.html

# Copiar las imágenes al contenedor
COPY images/ /usr/share/nginx/html/images/

# Exponer el puerto 80
EXPOSE 80

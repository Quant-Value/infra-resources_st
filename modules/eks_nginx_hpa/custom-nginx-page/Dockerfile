# Usar la imagen oficial de Nginx como base
FROM nginx:latest


# Copiar tu archivo HTML personalizado al contenedor
COPY index.html /usr/share/nginx/html/index.html

# Copiar las imágenes al contenedor
COPY images/ /usr/share/nginx/html/images/

COPY nginx.conf /etc/nginx/nginx.conf
# Exponer el puerto 80
EXPOSE 80

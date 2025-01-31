# Usamos una imagen base de Node.js
FROM node:16

# Definimos el directorio de trabajo
WORKDIR /usr/src/app 

# Copiamos el archivo package.json y lo instalamos
COPY package*.json ./
RUN npm install

# Copiamos todo el código de la aplicación al contenedor desde nuestra carpeta en vs code
COPY . .

# Exponemos el puerto 3000
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "index.js"]

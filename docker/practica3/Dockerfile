# Usa una imagen base más ligera: node:18-alpine
FROM node:18-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia solo el package.json y package-lock.json (si existe) para aprovechar la cache de Docker
COPY package*.json ./

# Instala solo las dependencias de producción y limpia la caché de npm para reducir el tamaño
RUN npm install --production && npm cache clean --force

# Copia solo los archivos necesarios y excluye los que no se necesitan con .dockerignore
COPY . .

# Expone el puerto en el que tu aplicación se ejecutará
EXPOSE 3000

# Define el comando para ejecutar la aplicación
CMD ["node", "app.js"]

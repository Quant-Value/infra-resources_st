# Usa la imagen base de Node.js
FROM node:18-alpine

WORKDIR /app

# Copia el package.json y el package-lock.json
COPY package*.json ./

# Instala las dependencias de producción
RUN npm install --production && npm install cors && npm cache clean --force

# Copia el resto de los archivos del backend
COPY . .

# Expone el puerto 3000
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "app.js"]

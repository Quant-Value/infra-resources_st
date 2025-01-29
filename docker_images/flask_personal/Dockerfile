# Usa una imagen base oficial de Python
FROM python:3.10-slim

# Setea el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el archivo requirements.txt al contenedor
COPY requirements.txt /app/

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código de la aplicación Flask al contenedor
COPY . /app/

# Expone el puerto 80
EXPOSE 80

# Define el comando para ejecutar la aplicación Flask
CMD ["python", "app.py"]


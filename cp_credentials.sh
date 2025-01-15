#!/bin/bash

# Definir las ubicaciones de origen y destino
origen="/mnt/c/Users/Salvacampudualdevops/.aws/credentials"
destino="/home/salva/.aws/credentials"

# Copiar el archivo
cp "$origen" "$destino"

# Verificar si la operación fue exitosa
if [ $? -eq 0 ]; then
    echo "El archivo se ha copiado correctamente."
else
    echo "Hubo un error al copiar el archivo."
fi

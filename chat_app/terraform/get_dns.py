#!/usr/bin/env python3
import sys
import subprocess
import json
from time import sleep

# Obtener el nombre del servicio del argumento
service_name = sys.argv[1]
sleep(10)
# Ejecutar el comando kubectl
result = subprocess.run(
    ["kubectl", "get", "svc", service_name, "-o", "jsonpath='{.status.loadBalancer.ingress[0].hostname}'"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE
)

# Capturar la salida y manejar errores
dns = result.stdout.decode().strip().strip("'")

# Devolver el DNS en formato JSON
if dns:
    print(json.dumps({"dns": dns}))
else:
    print(json.dumps({"dns": ""}))
    sys.exit(1)

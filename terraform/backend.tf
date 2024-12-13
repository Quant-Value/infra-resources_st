terraform {
  backend "s3" {
    bucket = "example"           # Nombre de tu bucket S3
    key    = "terraform/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "some region"                             # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

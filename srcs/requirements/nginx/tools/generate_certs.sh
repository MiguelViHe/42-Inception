#!/bin/bash

# ------------------------------------------------------------
# generate_certs.sh
# Script para generar certificados TLS para Nginx
# Usando el DOMAIN_NAME definido en el archivo .env
# ------------------------------------------------------------

#Alerta!: Si no deja ejecutar el script, darle permisos con:
# chmod +x generate_certs.sh

# Cargar variables del ".env". Lo hago asi porque se lanzará el script antes de levantar
# los contenedores y no puedo indicar el directorio .env en el docker-compose.yml
# De esta forma cargamos las variables del ".env" en el shell actual:
# grep -v '^#' -> filtra las lineas que no son comentarios
# xargs -> transforma las líneas KEY=VALUE en variables de entorno de Bash.
export $(grep -v '^#' ../../../.env | xargs)

echo "Dominio usado para el certificado: $DOMAIN_NAME"

CERT_FILE=../../../../$NGINX_CERT_FILE
KEY_FILE=../../../../$NGINX_KEY_FILE

if [ -f "$CERT_FILE" ] && [ -f "$KEY_FILE" ]; then
	echo "Los certificados ya existen en secrets/, no se generarán de nuevo."
	exit 0
fi

mkdir -p ../../../../secrets

# Generar certificado autofirmado
# -x509 -> certificado autofirmado TLS/SSL
# -nodes -> sin passphrase
# -days 365 -> válido por 1 año
# -newkey rsa:4096 -> nueva clave RSA de 4096 bits
openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
	-keyout "$KEY_FILE" \
	-out "$CERT_FILE" \
	-subj "/C=ES/ST=Madrid/L=Madrid/O=Inception/CN=${DOMAIN_NAME}"

echo "Certificados generados correctamente:"
echo "  Certificado: $CERT_FILE"
echo "  Clave privada: $KEY_FILE"
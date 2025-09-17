#!/bin/bash
# Reemplaza variables de entorno en el archivo de configuración de Nginx
# y luego inicia Nginx en primer plano (PID 1). (Normalmente nginx se ejecuta
# en segundo plano, pero en dockers el contenedor se detiene cuando el
# proceso principal (PID 1) se termina, por lo que necesitamos que nginx
# se ejecute en primer plano.)

envsubst '${DOMAIN_NAME}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'
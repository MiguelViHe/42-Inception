# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/12 15:12:29 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/14 11:21:20 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Install Nginx (todo en un solo RUN para reducir el número de capas)
# apt-get clean -> limpia la cache de apt-get para reducir el tamaño de la imagen
# rm -rf /var/lib/apt/lists/* -> elimina los indices descargados por apt-get update
# -y -> responde "si" a todas las preguntas que haga apt-get
# --no-install-recommends -> instala solo lo necesario, sin paquetes adicionales
# openssl -> para generar certificados SSL
# gettext-base -> para usar envsubst y sustituir variables en los archivos 
# de configuración.
# curl -> para el healthcheck
RUN apt-get update -y && \
	apt-get install -y --no-install-recommends nginx openssl gettext-base curl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Copiamos la plantilla de configuración donde estan las variables de entorno
# sin sustituir.
# Copiamos también el script de entrypoint que se encargará de sustiruir las
# variables sobre el default.conf final y inicializará en primer plano nginx
# con el archivo ya con las variables sustituidas.
COPY conf/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY tools/nginx_entrypoint.sh /usr/local/bin/nginx_entrypoint.sh
# BORRAR - RECUERDA se copia en el contenedor(bullseye), no en la máquina host

# chmod -R 755 /var/www/html -> Cambiamos los permisos del directorio /var/www/html
# para que el usuario www-data (el que usa nginx) pueda escribir en él.
# 	-R -> recursivo
# 	755 -> rwxr-xr-x (propietario puede leer, escribir y ejecutar; grupo y otros
# 	pueden leer y ejecutar)
# chown -R www-data:www-data /var/www/html -> cambia el propietario y grupo del
# directorio /var/www/html y de su contenido a www-data (el usuario y grupo que usa nginx)
# 	www-data:www-data -> propietario y grupo
# 	/var/www/html -> directorio donde se sirven los archivos web
RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

RUN chmod +x /usr/local/bin/nginx_entrypoint.sh
ENTRYPOINT ["/usr/local/bin/nginx_entrypoint.sh"]

# Healthcheck para verificar que nginx está funcionando correctamente.
# - interval=10s -> cada 10 segundos
# - timeout=5s -> si no responde en 5 segundos, se considera fallo
# - start-period=30s -> espera 30 segundos después de iniciar el contenedor antes
#   de empezar a hacer healthchecks
# - retries=3 -> si falla 3 veces consecutivas, se considera que el contenedor
#   no está saludable
# comprobar con docker inspect -f '{{.State.Health.Status}}' nginx
HEALTHCHECK --interval=10s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -k -f https://localhost/healthz

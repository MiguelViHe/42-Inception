# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/12 15:12:29 by mvidal-h          #+#    #+#              #
#    Updated: 2025/09/17 17:30:06 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Install Nginx (todo en un solo RUN para reducir el número de capas)
# rm -rf /var/lib/apt/lists/* -> elimina los indices descargados por apt-get update
# -y -> responde "si" a todas las preguntas que haga apt-get
# --no-install-recommends -> instala solo lo necesario, sin paquetes adicionales
# openssl -> para generar certificados SSL
# gettext-base -> para usar envsubst y sustituir variables en los archivos 
# de configuración.
RUN apt-get update && \
	apt-get install -y --no-install-recommends nginx openssl gettext-base && \
	rm -rf /var/lib/apt/lists/*

# Copiamos la plantilla de configuración donde estan las variables de entorno
# sin sustituir.
# Copiamos también el script de entrypoint que se encargará de sustiruir las
# variables sobre el default.conf final y inicializará en primer plano nginx
# con el archivo ya con las variables sustituidas.

COPY conf/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY tools/nginx_entrypoint.sh /usr/local/bin/nginx_entrypoint.sh
# BORRAR - RECUERDA se copia en el contenedor(bullseye), no en la máquina host

RUN chmod +x /usr/local/bin/nginx_entrypoint.sh
ENTRYPOINT ["/usr/local/bin/nginx_entrypoint.sh"]
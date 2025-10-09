# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/12 15:12:29 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/09 10:12:08 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Instalo mariadb (todo en un solo RUN para reducir el número de capas)
# apt-get clean -> limpia la cache de apt-get para reducir el tamaño de la imagen
# rm -rf /var/lib/apt/lists/* -> elimina los indices descargados por apt-get update
# -y -> responde "si" a todas las preguntas que haga apt-get
# --no-install-recommends -> instala solo lo necesario, sin paquetes adicionales 
# de configuración.
RUN apt-get update && \
	apt-get install -y --no-install-recommends mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# Copio script de entrypoint que se encargara de...
COPY tools/mariadb_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb_entrypoint.sh

# Sólo informativa (el contenedor de mariadb escucha en el puerto 3306)
EXPOSE 3306

# Defino entrypoint y comando principal
ENTRYPOINT ["/usr/local/bin/mariadb_entrypoint.sh"]
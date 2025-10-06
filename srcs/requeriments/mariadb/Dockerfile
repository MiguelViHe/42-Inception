# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/12 15:12:29 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/06 16:54:44 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Instalo mariadb (todo en un solo RUN para reducir el número de capas)
# rm -rf /var/lib/apt/lists/* -> elimina los indices descargados por apt-get update
# -y -> responde "si" a todas las preguntas que haga apt-get
# --no-install-recommends -> instala solo lo necesario, sin paquetes adicionales
# gettext-base -> para usar envsubst y sustituir variables en los archivos 
# de configuración.
RUN apt-get update && \
	apt-get install -y --no-install-recommends mariadb-server gettext-base && \
	rm -rf /var/lib/apt/lists/*

# Copio script de entrypoint que se encargara de...
COPY tools/mariadb-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

# Defino entrypoint y comando principal
ENTRYPOINT ["/usr/local/bin/mariadb-entrypoint.sh"]
CMD ["mysqld"]
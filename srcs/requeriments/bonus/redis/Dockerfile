# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/14 11:25:13 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/14 12:29:05 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Instalación de redis. Es un sistema de caché en memoria RAM que almacena
# resultados de peticiones PHP/MySQL para mejorar el rendimiento de WordPress.
RUN apt-get update -y && \
	apt-get install -y --no-install-recommends redis-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

#copia del archivo de configuración personalizado
COPY conf/redis.conf /etc/redis/redis.conf

# Sólo informativa (el contenedor de redis escucha en el puerto 6379)
EXPOSE 6379

# Los corchetes indican que se ejecutaran en primer plano. Tanto con ENTRYPOINT
# como con CMD, si no se usan corchetes, se ejecuta en segundo plano y el
# contenedor se detiene inmediatamente.
CMD ["redis-server", "/etc/redis/redis.conf"]
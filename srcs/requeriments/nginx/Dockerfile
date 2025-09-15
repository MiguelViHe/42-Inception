# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/12 15:12:29 by mvidal-h          #+#    #+#              #
#    Updated: 2025/09/15 15:45:03 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Install Nginx (todo en un solo RUN para reducir el número de capas)
# rm -rf /var/lib/apt/lists/* -> elimina los indices descargados por apt-get update
# -y -> responde "si" a todas las preguntas que haga apt-get
# --no-install-recommends -> instala solo lo necesario, sin paquetes adicionales
# openssl -> para generar certificados SSL
RUN apt-get update && \
	apt-get install -y --no-install-recommends nginx openssl && \
	rm -rf /var/lib/apt/lists/*

COPY conf/default.conf /etc/nginx/sites-enabled/default
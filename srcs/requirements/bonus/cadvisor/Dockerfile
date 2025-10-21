# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/14 11:25:13 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/21 17:40:10 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Imagen base mínima
FROM debian:bullseye-slim

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias (ca-certificates para conexiones HTTPS)
RUN apt update && apt install -y \
	wget ca-certificates \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Descargar binario oficial de cAdvisor
# Se descarga directamente desde los releases de Google
RUN wget https://github.com/google/cadvisor/releases/download/v0.37.0/cadvisor -O /usr/local/bin/cadvisor && \
	chmod +x /usr/local/bin/cadvisor

# Exponer el puerto web de cAdvisor
EXPOSE 8080

# Ejecutar cAdvisor
CMD ["/usr/local/bin/cadvisor", "-logtostderr", "-port=8080"]

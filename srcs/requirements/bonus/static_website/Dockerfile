# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/14 11:25:13 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/20 13:06:16 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Base mínima de Debian
FROM debian:bullseye-slim

# Evitar preguntas interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Instalar Nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear directorio para el contenido web
RUN mkdir -p /var/www/static_site

# Copiar archivos estáticos al contenedor
COPY html/ /var/www/static_site/

# Configurar Nginx para servir nuestro sitio
RUN rm /etc/nginx/sites-enabled/default
COPY conf/nginx.conf /etc/nginx/sites-available/static_site.conf
RUN ln -s /etc/nginx/sites-available/static_site.conf /etc/nginx/sites-enabled/static_site.conf

# Exponer puerto 80
EXPOSE 80

# Ejecutar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/14 11:25:13 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/21 15:39:42 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Base mínima de Debian
FROM debian:bullseye-slim

# Evitar preguntas interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Instalar PHP, Lighttpd y dependencias necesarias:
# lighttpd -> servidor web ligero. para adminer basta, pero en produccion es mejor usar
# nginx con php-fpm.
# php -> intérprete de PHP necesario para que lighttpd ejecute Adminer (PHP)
# php-mysqli -> extensión para conectar PHP con bases de datos MySQL/MariaDB
# wget, curl -> herramientas para descargar archivos desde internet y para hacer
# pruebas de conectividad.
RUN apt update && apt install -y \
	php7.4 php7.4-cgi php7.4-mysqli \
	lighttpd wget curl \
	&& apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Crear directorios necesarios y permisos
RUN mkdir -p /var/www/html /var/log/lighttpd /var/run/lighttpd && \
    chown -R www-data:www-data /var/www/html /var/log/lighttpd /var/run/lighttpd

# Descargar Adminer y moverlo al directorio raíz de Lighttpd
RUN mkdir -p /var/www/html && \
	wget "https://www.adminer.org/latest.php" -O /var/www/html/index.php && \
	chown -R www-data:www-data /var/www/html

# Habilitar módulos necesarios en lighttpd
# 	fastcgi -> permite a lighttpd comunicarse con intérpretes externos como PHP
# 	fastcgi-php -> configura fastcgi para trabajar con PHP
# NOTA PARA MI: Hoy en día, muchos servidores usan PHP-FPM (FastCGI Process Manager)
# , que es una versión más moderna de PHP FastCGI.
# Cumple el mismo rol, pero gestiona mejor los procesos PHP.
#	 Lighttpd usa php-cgi (FastCGI simple)
#	 Nginx o Apache normalmente usan php-fpm
RUN lighty-enable-mod fastcgi && \
	lighty-enable-mod fastcgi-php

# Exponer puerto 80
EXPOSE 80

# Ejecutar Lighttpd en primer plano
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

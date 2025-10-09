# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/12 15:12:29 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/09 12:58:28 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Instalación de wordpress con PHP-fpm (todo en un solo RUN para reducir el número de capas)
# -y -> responde "si" a todas las preguntas que haga apt-get
# --no-install-recommends -> instala solo lo necesario, sin paquetes adicionales
# de configuración.
# apt-get clean && -> limpia la cache de apt-get para reducir el tamaño de la imagen
# rm -rf /var/lib/apt/lists/* -> elimina los indices descargados por apt-get update
# Instalado:
# 	php8.2-fpm -> PHP FastCGI Process Manager, para ejecutar PHP con Nginx
#	php8.2-cli -> Interfaz de línea de comandos de PHP (necesario para wp-cli)
#	php8.2-mysqli -> extensión para conectar PHP con bases de datos MySQL/MariaDB
#	php8.2-curl -> Extensión PHP usada por WordPress para actualizaciones, plugins y APIs.
#	php8.2-gd -> Manipula imágenes (WordPress lo usa al subir fotos).
#	php8.2-mbstring -> Soporte para caracteres multibyte (acentos, UTF-8, emojis).
#	php8.2-xml -> Necesario para feeds RSS, exportaciones/importaciones y algunos plugins.
#	php8.2-zip -> Para descomprimir temas/plugins en formato ZIP.
#	ca-certificates -> Permite conexiones HTTPS seguras (sin esto wget o curl podrían fallar).
#	wget -> Descarga archivos desde Internet (wget https://wordpress.org/latest.tar.gz).
#	unzip -> Descomprime el archivo ZIP, por ejemplo el paquete de instalacion de wordpress.
#	mariadb-client -> Permite probar conexión a la base de datos desde el contenedor.
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	php8.2-fpm \
	php8.2-cli \
	php8.2-mysqli \
	php8.2-curl \
	php8.2-gd \
	php8.2-mbstring \
	php8.2-xml \
	php8.2-zip \
	ca-certificates \
	wget \
	unzip \
	mariadb-client && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Instalar wp-cli en la imagen. Herramienta de línea de comandos para gestionar instalaciones de WordPress.
# -q -> modo silencioso (no muestra salida)
# -O -> guarda el archivo con el nombre especificado
# chmod +x -> da permisos de ejecución al archivo descargado
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

# Crear directorio de WordPress y ajustar permisos
RUN mkdir -p /var/www/html && \
	chown -R www-data:www-data /var/www/html && \
	chmod -R 755 /var/www/html

# Copiar archivos de configuración personalizados (opcional)
# php.ini -> configuración general de PHP. (personalización de límites)
#			se copia en dos ubicaciones para asegurar que tanto PHP-FPM como la CLI usen la misma configuración.
# www.conf -> configuración específica de PHP-FPM (usuario, grupo, puerto de escucha).
COPY ./conf/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY ./conf/php.ini /etc/php/8.2/fpm/conf.d/custom.ini
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copiar el script de entrada y dar permisos de ejecución
COPY ./tools/wordpress_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress_entrypoint.sh

# Sólo informativa (el contenedor de mariadb escucha en el puerto 3306)
EXPOSE 9000

# Defino entrypoint y comando principal
ENTRYPOINT ["/usr/local/bin/wordpress_entrypoint.sh"]
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/14 11:25:13 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/16 16:36:14 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Instalación de vsftpd. Es un servidor FTP ligero y seguro.
RUN apt-get update -y && \
	apt-get install -y --no-install-recommends vsftpd && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Crear el directorio necesario para vsftpd y ajustar permisos
# /var/run/vsftpd/empty -> Lo usa para chrootear usuarios. chroot es una medida de seguridad
# que limita a los usuarios a un directorio específico, impidiendo que accedan a otras
# partes del sistema de archivos.
RUN mkdir -p /var/run/vsftpd/empty && \
chmod 755 /var/run/vsftpd/empty

#copia del archivo de configuración personalizado
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Copiar el script de entrada y dar permisos de ejecución
COPY ./tools/ftp_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/ftp_entrypoint.sh

# Sólo informativa (el contenedor de vsftpd escucha en el puerto 21 y rango 21000-21010)
EXPOSE 21 21000-21010

# Los corchetes indican que se ejecutaran en primer plano. Tanto con ENTRYPOINT
# como con CMD, si no se usan corchetes, se ejecuta en segundo plano y el
# contenedor se detiene inmediatamente.
ENTRYPOINT ["/usr/local/bin/ftp_entrypoint.sh"]
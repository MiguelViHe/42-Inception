# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/14 11:25:13 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/15 17:34:35 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

# Instalación de vsftpd. Es un servidor FTP ligero y seguro.
RUN apt-get update -y && \
	apt-get install -y --no-install-recommends vsftpd && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Crear usuario FTP con su directorio home y permisos adecuados
# -m -> crea el directorio home si no existe
# -d -> especifica el directorio home
# -s -> shell de login (nologin para que no pueda ejecutar comandos, solo FTP)
# echo ... | chpasswd -> establece la contraseña del usuario
RUN useradd -m -d /home/${FTP_USER} -s /usr/sbin/nologin ${FTP_USER} && \
	echo "${FTP_USER}:$(cat /run/secrets/ftp_user_password)" | chpasswd
	
#copia del archivo de configuración personalizado
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Sólo informativa (el contenedor de vsftpd escucha en el puerto 21 y rango 21000-21010)
EXPOSE 21 21000-21010

# Los corchetes indican que se ejecutaran en primer plano. Tanto con ENTRYPOINT
# como con CMD, si no se usan corchetes, se ejecuta en segundo plano y el
# contenedor se detiene inmediatamente.
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
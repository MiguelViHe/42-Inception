#!/bin/bash
set -e # hace que el script termine si cualquier comando devuelve un error

# Variables de entorno
FTP_USER=${FTP_USER:-"ftpuser"} # Usuario FTP, si no se define se usa por defecto "ftpuser"
FTP_USER_PASS=$(cat ${FTP_USER_PASSWORD_FILE}) # Contraseña del usuario FTP, leída desde el archivo

# Crear usuario FTP con su directorio home y permisos adecuados
# -m -> crea el directorio home si no existe
# -d -> especifica el directorio home
# -s -> shell de login (nologin para que no pueda ejecutar comandos, solo FTP)
# echo ... | chpasswd -> establece la contraseña del usuario
# En el if:
# id -u "$FTP_USER" -> verifica si el usuario ya existe (-u -> obtiene solamente el UID)
# 	>/dev/null 2>&1 -> redirige la salida estándar (>) y de error(2) al mismo sitio que (>&1)
# 	a /dev/null para evitar mostrar mensajes.
if id -u "$FTP_USER" >/dev/null 2>&1; then
	echo "[+] El usuario $FTP_USER ya existe, saltando creación."
else
	echo "[+] Creando usuario FTP: $FTP_USER"
	useradd -d /home/${FTP_USER} -s /usr/sbin/nologin ${FTP_USER} && \
	echo "${FTP_USER}:${FTP_USER_PASS}" | chpasswd
	echo "[+] Usuario $FTP_USER creado con éxito."
fi
	chown ${FTP_USER}:${FTP_USER} /home/${FTP_USER}
	chmod 755 /home/${FTP_USER}
	mkdir -p /home/${FTP_USER}/ftp
	chown -R ${FTP_USER}:${FTP_USER} /home/${FTP_USER}/ftp
	chmod 755 /home/${FTP_USER}/ftp

exec /usr/sbin/vsftpd /etc/vsftpd.conf
#!/bin/bash
set -e # hace que el script termine si cualquier comando devuelve un error

# Variables de entorno
FTP_USER=${FTP_USER:-"ftpuser"} # Usuario FTP, si no se define se usa por defecto "ftpuser"
FTP_USER_PASS=$(cat ${FTP_USER_PASSWORD_FILE}) # Contraseña del usuario FTP, leída desde el archivo

# Reemplaza variables de entorno en el archivo de configuración de vsftpd
# y guarda el resultado en /etc/vsftpd.conf
envsubst '${FTP_USER}' < /etc/vsftpd.conf.template > /etc/vsftpd.conf
rm /etc/vsftpd.conf.template

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
	useradd -m -d /home/${FTP_USER} -s /usr/sbin/nologin ${FTP_USER} && \
	echo "${FTP_USER}:${FTP_USER_PASS}" | chpasswd
	echo "[+] Usuario $FTP_USER creado con éxito."
fi
mkdir -p /home/${FTP_USER}/ftp
chown nobody:nogroup /home/${FTP_USER}/ftp
chmod a-w /home/${FTP_USER}/ftp
mkdir -p /home/${FTP_USER}/ftp/files_ftp
# Añadir ftpuser al grupo www-data para que pueda escribir donde WordPress escribe
usermod -aG www-data ${FTP_USER}

# Sed: busca coincidencias exactas
# -i -> edita el archivo en el lugar
# -r -> usa expresiones regulares extendidas
# "s/patrón/reemplazo/flags" -> sustituye patrón por reemplazo
# ejemplo concreto: 
#	"s/#write_enable=YES/write_enable=YES/1"
# En este caso concreo:
# ^[[:space:]]* -> busca el inicio de línea seguido de cualquier espacio en blanco
# auth[[:space:]]+ : busca la palabra "auth" seguida de uno o más espacios en blanco
# required[[:space:]]+ : busca la palabra "required" seguida de uno o más espacios en blanco
# pam_shells\.so : busca la palabra "pam_shells.so" (el punto se escapa con \ para que se interprete literalmente)
# # & : el símbolo & representa toda la cadena coincidente, por lo que se antepone un # para comentarla línea
# /etc/pam.d/vsftpd : archivo donde se realiza la sustitución
# Esto deshabilita la verificación de shells válidos para el usuario FTP, permitiendo que inicie sesión incluso si su shell es nologin.
sed -i -r "s/^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_shells\.so/# &/" /etc/pam.d/vsftpd

exec /usr/sbin/vsftpd /etc/vsftpd.conf
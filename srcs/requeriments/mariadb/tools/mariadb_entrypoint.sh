#!/bin/bash
set -e # hace que el script termine si cualquier comando devuelve un error

# aseguro que los directorios existen y tienen los permisos correctos.
# En principio se crean solos pero de esta forma incluso si alguien borra /var/lib/mysql
# o se monta un volumen vacío, MariaDB podrá escribir sin errores. Buena práctica.
# 	-p -> crea los directorios padres si no existen
# 	/var/lib/mysql -> directorio donde se almacenan los datos de mariadb
# 	/run/mysqld -> directorio donde se almacenan los archivos de socket y PID de mariadb
# chown -R mysql:mysql -> cambia el propietario y grupo del directorio a mysql
# 	-R -> recursivo
# 	mysql:mysql -> propietario y grupo
mkdir -p /var/lib/mysql /run/mysqld && \
chown -R mysql:mysql /var/lib/mysql /run/mysqld

#verificación de si la base de datos ya ha sido inicializada
# Si no existe el directorio /var/lib/mysql/mysql, significa que la base de datos
# no ha sido inicializada, por lo que procedemos a inicializarla.
# Si ya existe, significa que la base de datos ya ha sido inicializada,
# por lo que no hacemos nada.
# Esto evita que se sobrescriban los datos cada vez que se reinicia el contenedor
# o se monta un volumen con datos ya existentes.
# mysqld --initialize-insecure -> inicializa la base de datos sin contraseña para root.
# No es peligroso porque la vamos a definir nosotros mismos desde secrets a continuación.
# --user=mysql -> ejecuta el comando como el usuario mysql
# --datadir=/var/lib/mysql -> especifica el directorio donde se almacenan los datos
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Base de datos no encontrada, inicializando..."
	mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
else
	echo "Base de datos ya inicializada, saltando inicialización."
fi

# arrancar MariaDB en segundo plano sin red (solo local)
# mysqld_safe -> script que arranca mysqld y lo mantiene en ejecución segura
# --skip-networking -> deshabilita las conexiones de red, solo permite conexiones locales
# & -> ejecuta el comando en segundo plano para que el script continúe.
# pid="$!" -> guarda el PID del proceso temporal, para poder detenerlo más tarde.
mysqld_safe --skip-networking &
pid="$!"

# esperar a que MariaDB esté listo
until mysqladmin ping --silent; do
	echo "Esperando a que MariaDB esté disponible..."
	sleep 1
done


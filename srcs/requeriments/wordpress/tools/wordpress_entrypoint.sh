#!/bin/bash
set -e  # Salir inmediatamente si cualquier comando falla

# --- Variables de entorno ---
WPDB_USER_PASS=$(cat "${WPDB_USER_PASSWORD_FILE}")
WPDB_ROOT_PASS=$(cat "${WPDB_ROOT_PASSWORD_FILE}")
WP_USER_PASS=$(cat "${WP_USER_PASSWORD_FILE}")
WP_ADMIN_PASS=$(cat "${WP_ADMIN_PASSWORD_FILE}")

wait_for_db() {
	# Para el chequeo nos vale con el usuario más básico
	until mysqladmin ping -h "$DB_HOSTNAME" -u "$WPDB_USER" -p"$WPDB_USER_PASS" --silent; do
		echo "Esperando a que MariaDB esté disponible..."
		sleep 1
	done
	echo "[+] Base de datos disponible."
}

wait_for_redis() {
	# Esperar a que Redis esté listo
	until redis-cli -h redis -p 6379 ping | grep -q PONG; do
		echo "Esperando a que Redis esté disponible..."
		sleep 1
	done
	echo "[+] Redis disponible."
}

install_and_config_redis() {
	# --- Esperar a que Redis esté listo ---
	wait_for_redis

	# --- Instalar y activar Redis Object Cache ---
	if  ! wp plugin is-installed redis-cache --allow-root ; then
		echo "[+] WP: Instalando Redis Object Cache..."
		wp plugin install redis-cache --activate --allow-root
	fi

	# --- Configurar Redis en wp-config.php ---
	echo "[+] WP: Configurando Redis en wp-config.php..."
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_CACHE true --allow-root

	# --- Activar la caché de objetos ---
	echo "[+] WP: Activando Redis Object Cache..."
	wp redis enable --allow-root
}

# --- Comprobar si WordPress ya está instalado ---
if [ ! -f "$WP_DIR/wp-config.php" ]; then
	# --- Preparar directorio ---
	cd "$WP_DIR"

	# --- Esperar a que la base de datos esté lista ---
	wait_for_db

	# --- Descargar e instalar WordPress con WP-CLI ---
	echo "[+] Descargando WordPress..."
	wp core download --allow-root

	# Pero para crear la base de datos de wordpress necesitamos el usuario root
	echo "[+] Creando wp-config.php..."
	wp config create \
		--dbname="$DB_NAME" \
		--dbuser="$WPDB_ROOT_USER" \
		--dbpass="$WPDB_ROOT_PASS" \
		--dbhost="$DB_HOSTNAME" \
		--allow-root

	echo "[+] Instalando WordPress..."
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="mvidal-h WordPress Site" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASS" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root

	# --- Crear usuario adicional ---
	if [ ! -z "$WP_USER" ]; then
		echo "[+] Creando usuario secundario..."
		wp user create "$WP_USER" "$WP_USER_EMAIL" \
			--user_pass="$WP_USER_PASS" \
			--role=subscriber \
			--allow-root
	fi

	# --- Ajustar permisos para directorios y archivos de la instalación de WordPress ---
	chown -R www-data:www-data "$WP_DIR"
	chmod -R 755 "$WP_DIR"

	# --- Instalar y configurar Redis Object Cache ---
	install_and_config_redis

	# --- Arrancar PHP-FPM en primer plano ---
	echo "[+] Arrancando PHP-FPM..."
	exec php-fpm7.4 -F
fi
echo "[+] WordPress ya instalado. Saltando instalación..."
exec php-fpm7.4 -F  # Arranca PHP-FPM en primer plano




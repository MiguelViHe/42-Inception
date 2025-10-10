#!/bin/bash
set -e  # Salir inmediatamente si cualquier comando falla

# --- Variables de entorno ---
WPDB_USER_PASS=$(cat "${WPDB_USER_PASSWORD_FILE}")
WP_USER_PASS=$(cat "${WP_USER_PASSWORD_FILE}")
WP_ADMIN_PASS=$(cat "${WP_ADMIN_PASSWORD_FILE}")

wait_for_db() {

	until mysqladmin ping -h "$DB_HOSTNAME" -u "$WPDB_USER" -p "$WPDB_USER_PASS" --silent; do
		echo "Esperando a que MariaDB esté disponible..."
		sleep 1
	done
	echo "[+] Base de datos disponible."
}

# --- Comprobar si WordPress ya está instalado ---
if [ ! -f "$WP_DIR/wp-config.php" ]; then
	# --- Preparar directorio ---
	mkdir -p "$WP_DIR"
	chown -R www-data:www-data "$WP_DIR"
	chmod -R 755 "$WP_DIR"
	cd "$WP_DIR"

	# --- Esperar a que la base de datos esté lista ---
	wait_for_db

	# --- Descargar e instalar WordPress con WP-CLI ---
	echo "[+] Descargando WordPress..."
	wp core download --allow-root

	echo "[+] Creando wp-config.php..."
	wp config create \
		--dbname="$DB_NAME" \
		--dbuser="$WPDB_USER" \
		--dbpass="$WPDB_USER_PASS" \
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

	# --- Arrancar PHP-FPM en primer plano ---
	echo "[+] Arrancando PHP-FPM..."
	exec php-fpm8.2 -F
fi
echo "[+] WordPress ya instalado. Saltando configuración inicial."
exec php-fpm8.2 -F  # Arranca PHP-FPM en primer plano




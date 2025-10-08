# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/18 16:32:57 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/08 12:35:46 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

USER_NAME = $(shell whoami)
DATA_DIR = /home/$(USER_NAME)/data

all: up

setup:
# 	sudo mkdir -p ${USER_NAME}/wordpress
# 	sudo chown -R 101:101 ${USER_NAME}/wordpress
# 	sudo chmod 755 ${USER_NAME}/wordpress

	sudo mkdir -p ${DATA_DIR}/mariadb
	sudo chown -R 101:101 ${DATA_DIR}/mariadb
	sudo chmod 750 ${DATA_DIR}/mariadb

# -f: especifica el archivo de configuración (no el por defecto)
# up: crea y arranca los contenedores
# -d: detached (en segundo plano). No deja la terminal pillada mostrando sus logs.
# --build: fuerza la reconstrucción de las imágenes (aunque no haya cambios)
up:	setup
	@docker compose -f srcs/docker-compose.yml up -d --build

# down: para y elimina los contenedores, redes y opcionalmente, volúmenes creados por 'up'
# --remove-orphans: elimina contenedores que ya no están en el docker-compose.yml
down:
	@docker compose -f srcs/docker-compose.yml down --remove-orphans

# logs: muestra los logs de los contenedores
# -f: sigue mostrando los logs en tiempo real (como tail -f)
logs:
	@docker compose -f srcs/docker-compose.yml logs -f

re: down up

# Elimina contenedores, redes e imágenes creadas por 'up'
# -f en image prune: no pide confirmación. Elimina todas las imágenes "dangling"
clean:
	@docker compose -f srcs/docker-compose.yml down --remove-orphans
	@docker image prune -f

# Elimina contenedores, redes, imágenes y volúmenes creados por 'up'
# --volumes: elimina los volúmenes asociados a los contenedores
# -a en image prune: elimina todas las imágenes no usadas por al menos un contenedor
# docker container prune -f: elimina todos los contenedores detenidos
# docker volume prune -f: elimina todos los volúmenes no usados por al menos un contenedor
# sudo rm -rf /home/mvidal-h/data/: elimina los datos persistentes en el host
fclean:
	@echo "🧹 Deteniendo y eliminando contenedores y volúmenes del proyecto..."
	@docker compose -f srcs/docker-compose.yml down --volumes --remove-orphans
	@echo "🧹 Limpiando contenedores detenidos..."
	@docker container prune -f
	@echo "🧹 Limpiando imágenes no usadas..."
	@docker image prune -af
	@echo "🧹 Limpiando volúmenes no usados..."
	@docker volume prune -f
	@if [ -d "$(DATA_DIR)" ]; then \
		echo "🗑 Borrando datos persistentes en $(DATA_DIR)..."; \
		sudo rm -rf "$(DATA_DIR)"; \
	else \
		@echo "✅ No se encontraron datos persistentes en $(DATA_DIR)"; \
	fi
	@echo "✅ Limpieza completa."


volumes:
	@docker volume ls
	@for vol in $(shell docker volume ls -q); do \
		echo "🔍 $$vol:"; \
		docker volume inspect $$vol; \
	done

status:
	@echo "🟦 Docker containers:"
	@docker ps -a --filter name=nginx --filter name=wordpress --filter name=mariadb

	@echo "🟩 Docker volumes:"
	@docker volume ls | grep -E 'srcs_mariadb_data|srcs_wordpress_data' || echo "No volumes found"

	@echo "🟨 Docker volume paths:"
	@echo "MariaDB:    $(DATA_DIR)/mariadb"
	@echo "WordPress:  $(DATA_DIR)/wordpress"
	@if [ -d "$(DATA_DIR)" ]; then \
		sudo ls -l $(DATA_DIR); \
	else \
		echo "🔴 No se puede listar $(DATA_DIR). Directorio inexistente."; \
	fi

	@echo "🟪 Docker network:"
	@docker network ls | grep inception || echo "No network found"
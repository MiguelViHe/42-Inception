# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/18 16:32:57 by mvidal-h          #+#    #+#              #
#    Updated: 2025/09/18 17:10:20 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

all: up

# setup_dirs:
# 	sudo mkdir -p /home/mvidal-h/data/wordpress
# 	sudo chown -R 101:101 /home/mvidal-h/data/wordpress
# 	sudo chmod 755 /home/mvidal-h/data/wordpress
# 	sudo mkdir -p /home/mvidal-h/data/mariadb
# 	sudo chown -R 101:101 /home/mvidal-h/data/mariadb
# 	sudo chmod 750 /home/mvidal-h/data/mariadb

# -f: especifica el archivo de configuración (no el por defecto)
# up: crea y arranca los contenedores
# -d: detached (en segundo plano). No deja la terminal pillada mostrando sus logs.
# --build: fuerza la reconstrucción de las imágenes (aunque no haya cambios)
up:	#setup_dirs
	docker compose -f srcs/docker-compose.yml up -d --build

# down: para y elimina los contenedores, redes y opcionalmente, volúmenes creados por 'up'
# --remove-orphans: elimina contenedores que ya no están en el docker-compose.yml
down:
	docker compose -f srcs/docker-compose.yml down --remove-orphans

# logs: muestra los logs de los contenedores
# -f: sigue mostrando los logs en tiempo real (como tail -f)
logs:
	docker compose -f srcs/docker-compose.yml logs -f

re: down up

# Elimina contenedores, redes e imágenes creadas por 'up'
# -f en image prune: no pide confirmación. Elimina todas las imágenes "dangling"
clean:
	docker compose -f srcs/docker-compose.yml down --remove-orphans
	docker image prune -f

# Elimina contenedores, redes, imágenes y volúmenes creados por 'up'
# --volumes: elimina los volúmenes asociados a los contenedores
# -a en image prune: elimina todas las imágenes no usadas por al menos un contenedor
# docker container prune -f: elimina todos los contenedores detenidos
# docker volume prune -f: elimina todos los volúmenes no usados por al menos un contenedor
# sudo rm -rf /home/mvidal-h/data/: elimina los datos persistentes en el host
# docker volume rm ...: elimina volúmenes específicos (si existen)
# || true: evita que falle el make si los volúmenes no existen
fclean:
	docker compose -f srcs/docker-compose.yml down --volumes --remove-orphans
	docker container prune -f
	docker image prune -af
# 	docker volume prune -f
# 	sudo rm -rf /home/mvidal-h/data/
# 	docker volume rm srcs_mariadb_data srcs_wordpress_data || true

# volumes:
# 	docker volume ls
# 	docker volume inspect srcs_mariadb_data
# 	docker volume inspect srcs_wordpress_data

status:
	@echo "🟦 Docker containers:"
	@docker ps -a --filter name=nginx --filter name=wordpress --filter name=mariadb

	@echo "\n🟩 Docker volumes:"
	@docker volume ls | grep -E 'mariadb_data|wordpress_data' || echo "No volumes found"

# 	@echo "\n🟨 Docker volume paths:"
# 	@echo "MariaDB:    /home/mvidal-h/data/mariadb"
# 	@echo "WordPress:  /home/mvidal-h/data/wordpress"
# 	@sudo ls -l /home/mvidal-h/data/

	@echo "\n🟪 Docker network:"
	@docker network ls | grep inception-network || echo "No network found"
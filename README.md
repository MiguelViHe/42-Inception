🐳 42-Inception

Inception —  Este proyecto se centra en la construcción desde cero de una infraestructura Docker completa para ejecutar un sitio web WordPress con todos sus servicios de backend de forma aislada y orquestada. Forma parte del Common Core de 42 Madrid.

📌 Qué es 42-Inception

Inception es un proyecto de DevOps / SRE / administración de sistemas que te enseña a:

🔹Construir imágenes Docker desde Dockerfiles propios.
🔹Orquestar múltiples servicios usando Docker Compose.
🔹Configurar redes, volúmenes persistentes y comunicación entre contenedores.
🔹Desplegar una web completa con componentes backend y administración.

Los servicios que conforman esta infraestructura son:
✅ NGINX, MariaDB, WordPress, PHP-FPM
✅ Redis (cache)
✅ FTP Server
✅ Adminer (gestor de bases de datos)
✅ cAdvisor (monitorización de contenedores)

📁 Estructura del proyecto

La estructura del repositorio es:

42-Inception/
├── srcs/
│   ├── nginx/
│   │   ├── Dockerfile
│   │   └── conf/…
│   ├── wordpress/
│   │   └── Dockerfile
│   ├── mariadb/
│   │   └── Dockerfile
│   ├── redis/
│   │   └── Dockerfile
│   ├── ftp/
│   │   └── Dockerfile
│   ├── adminer/
│   │   └── Dockerfile
│   ├── cadvisor/
│   │   └── Dockerfile
│   ├── docker-compose.yml
│   └── .env.example
├── Makefile
└── README.md


Esta organización permite construir cada imagen y servicio de forma independiente, con Dockerfiles personalizados y configuraciones de red y volúmenes.

🛠️ Requisitos previos

Antes de iniciar:

✔️ Tener Docker y Docker Compose instalados (en Linux preferiblemente).
✔️ Instalar tus herramientas básicas (make, openssl, shell).
✔️ Usar una máquina o entorno donde puedas abrir puertos y generar certificados TLS.

🚀 Instalación y arranque

Clonar el repositorio:

git clone https://github.com/MiguelViHe/42-Inception.git
cd 42-Inception


Configurar variables de entorno:

cp srcs/.env.example srcs/.env
# Edita .env con tus dominios, contraseñas y credenciales.


Construir y arrancar todos los servicios:

make


Esto:

construye todas las imágenes desde los Dockerfiles en srcs/,

crea los contenedores y red de servicios,

levanta el stack completo.

📌 Servicios incluidos
🔹 Servicios principales
Servicio	Función
NGINX	Servidor web / proxy inverso con TLS configurado
WordPress + PHP-FPM	CMS con FastCGI para servir PHP
MariaDB	Base de datos relacional para WordPress

Estos son obligatorios para completar la parte base del proyecto.

📦 Servicios Bonus

(Si están presentes en tu versión)

Servicio	Utilidad
Redis	Cache para mejorar rendimiento
FTP Server	Servidor FTP para subir archivos
Adminer	Interfaz web para gestionar bases de datos
cAdvisor	Monitorización del uso de recursos de contenedores

Estos bonus son opcionales pero muy valorados para demostrar conocimientos avanzados en infraestructuras Docker.

📚 Volúmenes y redes

El proyecto usa volúmenes Docker para mantener persistencia de:

WordPress (archivos de sitio).

MariaDB (base de datos).

Redis (si aplica).

La red Docker interna conecta los servicios, de forma que solo NGINX expone puertos hacia el exterior mientras los demás servicios están aislados internamente.

🧪 Comandos útiles (Makefile)

make — Construye y arranca todo.

make up — Arranca servicios sin reconstruir.

make down — Detiene y elimina contenedores.

make clean — Limpia contenedores, imágenes y volúmenes.

make rmi — Elimina imágenes Docker creadas.

(Revisa tu Makefile ya que puede cambiar ligeramente.)

📌 Buenas prácticas

📍 Certificados TLS: Genera certificados auto-firmados con OpenSSL para HTTPS.
📍 Seguridad: Nunca expongas puertos innecesarios.
📍 Optimización: Utiliza Redis para cachear sesiones o consultas frecuentes.
📍 Monitorización: cAdvisor te ayuda a observar rendimiento y consumo.

🧠 Qué se aprende con este proyecto

Este proyecto desarrolla habilidades en:

🎯 Docker & Docker Compose

🛠️ Construcción de imágenes personalizadas

🌐 Configuración de redes y servicios en contenedores

📦 Volúmenes persistentes

🔒 Seguridad (TLS/SSL)

🧪 Monitorización de servicios en producción

📁 Automatización con Makefile

📜 Licencia

Puedes elegir la licencia que prefieras (p. ej., MIT, Apache 2.0, GPL) para permitir colaboración abierta.

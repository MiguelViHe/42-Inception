🐳 42-Inception

**Inception** —  Este proyecto se centra en la construcción desde cero de una infraestructura Docker completa para ejecutar un sitio web WordPress con todos sus servicios de backend de forma aislada y orquestada. Forma parte del Common Core de 42 Madrid.

📌 Qué es 42-Inception

Inception es un proyecto de DevOps / administración de sistemas que te enseña a:

 🔹Construir imágenes Docker desde Dockerfiles propios.
 
 🔹Orquestar múltiples servicios usando Docker Compose.
 
 🔹Configurar redes, volúmenes persistentes y comunicación entre contenedores.
 
 🔹Desplegar una web completa con componentes backend y administración.

📦 Servicios incluidos obligatorios para completar la parte base del proyecto.

🔹NGINX	Servidor web / proxy inverso con TLS configurado

🔹WordPress + PHP-FPM	CMS con FastCGI para servir PHP

🔹MariaDB	Base de datos relacional para WordPress

📦 Servicios Bonus

🔹Redis	Cache para mejorar rendimiento

🔹FTP Server para subir archivos

🔹Adminer:	Interfaz web para gestionar bases de datos

🔹cAdvisor:	Monitorización del uso de recursos de contenedores

🔹Web estática

---

📁 Estructura del proyecto

```text
42-Inception/
├── secrets/ (no incluido desde el repositorio. Se incluirá desde una ubicación segura)
├── srcs/
│   ├── requiriments/
│   │   ├── bonus/
|   │   │   ├── adminer/
|   │   │   ├── cadvisor/
|   │   │   ├── ftp/
|   │   │   ├── redis/
|   │   │   └── static_website/
│   │   ├── mariadb/
|   │   │   ├── conf/
|   │   │   ├── tools/
|   │   │   ├── .dockerignore
|   │   │   └── Dockerfile
│   │   ├── nginx/
|   │   │   ├── conf/
|   │   │   ├── tools/
|   │   │   ├── .dockerignore
|   │   │   └── Dockerfile
│   │   └── wordpress/
|   │   │   ├── conf/
|   │   │   ├── tools/
|   │   │   ├── .dockerignore
|   │   │   └── Dockerfile
│   ├── .env
│   ├── docker-compone.yml
├── Makefile
└── README.md
```
Esta organización permite construir cada imagen y servicio de forma independiente, con Dockerfiles personalizados y configuraciones de red y volúmenes.

---

🛠️ Requisitos previos

✔️ Tener Docker y Docker Compose instalados (en Linux preferiblemente).
✔️ Usar una máquina o entorno donde puedas abrir puertos y generar certificados TLS.

---

🚀 Instalación y arranque

🔹Clonar el repositorio:

```bash
git clone https://github.com/MiguelViHe/42-Inception.git
cd 42-Inception
```

🔹Configurar variables de entorno:

# Edita .env con tus dominios, contraseñas y credenciales.

🔹Construir y arrancar todos los servicios:

```bash
make
```
Con esto:

🔹construye todas las imágenes desde los Dockerfiles en srcs/.

🔹crea los contenedores y red de servicios.

🔹levanta el stack completo.

---

📚 Volúmenes y redes
El proyecto usa volúmenes Docker para mantener persistencia de:

🔹WordPress (archivos de sitio).

🔹MariaDB (base de datos).

🔹Redis (para mantener la cache de la RAM de una sesion a otra.

La red Docker interna conecta los servicios, de forma que solo NGINX expone puertos hacia el exterior mientras los demás servicios están aislados internamente.

---

🧪 Comandos útiles (Makefile)


🔹make — Construye y arranca todo.

🔹make setup — Contruye y da permisos a los volumenes en disco.

🔹make up — Arranca servicios sin reconstruir.

🔹make down — Detiene y elimina contenedores.

🔹make clean — Elimina contenedores, redes e imágenes creadas por 'up'

🔹make fclean — Elimina todo lo creado por el proyecto, incluidas imagenes, contenedores, redes y volumenes para que todo quede tal cual estaba antes de hacer make.

🔹make deepre — Reconstruye las imágenes y reinicia los contenedores sin usar caché.

🔹make logs — Muestra los logs de logs de los contenedores.

🔹make volumes — Muestra info sobre los volumenes creados.

🔹make status — Muestra info de los contenedores, los volumenes y de la red.

---

📌 Buenas prácticas

🔹 Certificados TLS: Genera certificados auto-firmados con OpenSSL para HTTPS.

🔹 Seguridad: Nunca expongas puertos innecesarios. Uso de secrets para no exponer información confidencial.

🔹 Optimización: Utiliza Redis para cachear sesiones o consultas frecuentes.

🔹 Monitorización: cAdvisor te ayuda a observar rendimiento y consumo.

---

🧠 Qué se aprende con este proyecto

🔹 Docker & Docker Compose

🔹 Construcción de imágenes personalizadas

🔹 Configuración de redes y servicios en contenedores

🔹 Volúmenes persistentes

🔹 Seguridad (TLS/SSL) y uso de Secrets

🔹 Monitorización de servicios en producción

🔹 Automatización con Makefile

---

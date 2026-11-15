# Nombre del proyecto para agrupar contenedores, redes, volumenes y Docker
NAME = inception

# Ruta al archivo principal que orquesta todos los contenedores
COMPOSE_FILE = ./src/docker-compose.yml

# Rutas fisicas en la VM (Host) donde persistiran los datos al cerrar el Docker.
# El subject exige que los volumenes apunten a /home/<login>/data
DATA_DIR = /home/unovo-ru/data
DB_DIR = $(DATA_DIR)/mariadb
WP_DIR = $()
























# MAKEFILE COMENTADO PARA NO PERDERLO (HACERLO BIEN)







# # ==============================================================================
# # VARIABLES DE CONFIGURACION DEL MAKEFILE
# # ==============================================================================

# # Nombre del proyecto para agrupar contenedores, redes y volumenes en Docker
# NAME = inception

# # Ruta al archivo principal que orquesta todos los contenedores
# COMPOSE_FILE = ./srcs/docker-compose.yml

# # Rutas fisicas en la maquina virtual (Host) donde persistiran los datos.
# # El subject exige que los volumenes apunten a /home/<login>/data
# DATA_DIR = /home/unovo-ru/data
# DB_DIR = $(DATA_DIR)/mariadb
# WP_DIR = $(DATA_DIR)/wordpress


# # ==============================================================================
# # REGLAS PRINCIPALES DE EJECUCION (CICLO DE VIDA)
# # ==============================================================================

# # Regla por defecto al ejecutar simplemente "make". Llama a la regla "up".
# all: up

# # Crea las carpetas fisicas en la VM (si no existen) y levanta la infraestructura:
# # - mkdir -p: crea el directorio padre e hijos sin dar error si ya existen.
# # - docker compose -f: especifica que archivo docker-compose.yml usar.
# # - up --build -d: construye las imagenes desde sus Dockerfiles (--build) y
# #   arranca los contenedores en segundo plano (-d / detached) liberando la terminal.
# up:
# 	@mkdir -p $(DB_DIR) $(WP_DIR)
# 	@docker compose -f $(COMPOSE_FILE) -p $(NAME) up --build -d

# # Detiene los contenedores en ejecucion sin borrar ni las imagenes ni los datos.
# # Es util para pausar el proyecto sin perder la base de datos ni los usuarios creados.
# stop:
# 	@docker compose -f $(COMPOSE_FILE) -p $(NAME) stop

# # Vuelve a arrancar contenedores que estaban previamente detenidos con "make stop".
# start:
# 	@docker compose -f $(COMPOSE_FILE) -p $(NAME) start


# # ==============================================================================
# # REGLAS DE LIMPIEZA Y RECONSTRUCCION
# # ==============================================================================

# # Detiene y elimina los contenedores y la red interna creada por Docker Compose,
# # pero mantiene intactas las imagenes construidas y los volumenes de datos.
# down:
# 	@docker compose -f $(COMPOSE_FILE) -p $(NAME) down

# # Limpieza intermedia: ejecuta "down" y ademas borra las imagenes y volumenes
# # asociados al compose (-v --rmi all), pero conserva tus carpetas fisicas en /home.
# clean:
# 	@docker compose -f $(COMPOSE_FILE) -p $(NAME) down -v --rmi all

# # Limpieza total (reset de fabrica):
# # 1. Ejecuta "clean" para eliminar contenedores, redes, volumenes Docker e imagenes.
# # 2. docker system prune -af: borra cualquier cache de construccion o imagen huerfana.
# # 3. sudo rm -rf $(DATA_DIR): elimina las carpetas fisicas de datos en la VM para
# #    que la proxima vez que hagas "make" se cree la base de datos desde cero.
# fclean: clean
# 	@docker system prune -af
# 	@sudo rm -rf $(DATA_DIR)

# # Reconstruye todo el proyecto desde cero tras hacer una limpieza total.
# re: fclean all


# # ==============================================================================
# # REGLAS DE DIAGNOSTICO (UTILES EN DESARROLLO Y EVALUACION)
# # ==============================================================================

# # Muestra el estado actual de los contenedores (si estan Up, Exited, puertos, etc.)
# ps:
# 	@docker compose -f $(COMPOSE_FILE) -p $(NAME) ps

# # Muestra los logs en tiempo real de todos los contenedores (salir con Ctrl + C).
# # Muy util para depurar errores de arranque en MariaDB, WordPress o NGINX.
# logs:
# 	@docker compose -f $(COMPOSE_FILE) -p $(NAME) logs -f


# # Indica a Make que estas palabras son nombres de ordenes y no archivos reales,
# # evitando conflictos si en el futuro existiera un fichero llamado "clean" o "up".
# .PHONY: all up stop start down clean fclean re ps logs
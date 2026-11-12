COMPOSE_FILE := srcs/docker-compose.yml
COMPOSE := docker compose -f $(COMPOSE_FILE)

.PHONY: all build up down clean fclean re

all: up

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --volumes --remove-orphans

fclean: clean
	docker image prune -af
	docker volume prune -f

re: fclean all

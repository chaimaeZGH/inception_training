NAME = inception

ENV_FILE = ./srcs/.env
include $(ENV_FILE)

DOCKER_COMPOSE = docker compose
DC_FILE = ./srcs/docker-compose.yml
DATA_DIR = /home/${USER}/data

all: up

up:
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	@$(DOCKER_COMPOSE) -f $(DC_FILE) up -d --build

down:
	@$(DOCKER_COMPOSE) -f $(DC_FILE) down

stop:
	@$(DOCKER_COMPOSE) -f $(DC_FILE) stop

start:
	@$(DOCKER_COMPOSE) -f $(DC_FILE) start

restart:
	@$(DOCKER_COMPOSE) -f $(DC_FILE) restart

logs:
	@$(DOCKER_COMPOSE) -f $(DC_FILE) logs -f

clean:
	@$(DOCKER_COMPOSE) -f $(DC_FILE) down -v

fclean: clean
	@docker system prune -a -f --volumes
	@docker run --rm -v $(DATA_DIR):/data alpine sh -c 'rm -rf /data/mariadb /data/wordpress'

re: fclean all

.PHONY: all up down stop start restart logs clean fclean re
NAME = inception

# Correct path - docker-compose.yml is in srcs/
DOCKER_COMPOSE = docker compose
DC_FILE = ./srcs/docker-compose.yml

all: up

up:
	@mkdir -p /home/${USER}/data/mariadb /home/${USER}/data/wordpress /home/${USER}/data/redis
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
	@docker run --rm -v /home/${USER}/data:/data alpine sh -c 'rm -rf /data/mariadb /data/wordpress /data/redis'

re: fclean all

.PHONY: all up down stop start restart logs clean fclean re
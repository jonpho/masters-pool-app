build:
	@docker compose build

up:
	@docker compose up
	@docker compose run web rails db:migrate
	@docker compose run web rails db:seed

db_migrate:
	@docker compose run web rails db:migrate

db_seed:
	@docker compose run web rails db:seed

db_sh:
	@docker compose exec -it db sh

down:
	@docker compose down

app_sh:
	@docker compose exec -it app sh

app_destroy:
	@yes | docker container prune
	@yes | docker image prune -a
	@yes | docker volume prune
	@yes | docker system prune --volumes

build:
	@docker compose build

up:
	@docker compose up

db_migrate:
	@docker compose run web rails db:migrate

# The Master's Golf Pool Application

## Tech Stack

- Ruby on Rails
- mysql 8
- Docker

## Docker Setup Instructions

1. run the following command `docker compose up`
2. run the follwing to migrate the db `docker compose run web rails db:migrate`

## Local Setup Instructions

1. Clone Repository
2. Bundle Install
3. If the mysql2 fails to install check the mysql2 gem page for more directions https://github.com/brianmario/mysql2
4. DB Migrations rails db:create
5. rails db:migrate

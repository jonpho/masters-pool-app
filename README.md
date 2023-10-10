# The Master's Golf Pool Application

## Tech Stack

- Ruby on Rails
- mysql 8
- Docker

## Docker One Command Setup Instruction

1. Run the following command `make clean_build` This command will build and setup the DB then start the containers

## Docker Step By Step Instructions

1. Run the following command to build the containers `make build`
2. Run the following commmand to setup the DB `make db_setup`
3. Start the containers for the app `make up`

## Make Commands of Note

`make up` Starts All Containers
`make down` Stops All Containers

## Local Setup Instructions

1. Clone Repository
2. Bundle Install
3. If the mysql2 fails to install check the mysql2 gem page for more directions https://github.com/brianmario/mysql2
4. DB Migrations rails db:create
5. rails db:migrate

If a server.pid error appears delete the server.pid file in the tmp folder

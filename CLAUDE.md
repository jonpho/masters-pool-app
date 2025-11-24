# CLAUDE.md - Masters Pool Application AI Assistant Guide

## Project Overview

This is a Ruby on Rails application for managing a Masters Golf Tournament pool. Users can submit their golfer picks, track leaderboards, and participate in a golf tournament prediction competition.

**Key Domain Concepts:**
- **Golfers**: Professional and amateur golfers participating in the Masters Tournament
- **Users**: Pool participants who submit golfer picks
- **Flights**: Groups of golfers organized by world ranking or category
- **Leaderboards**: Tournament results and scoring data
- **User Submissions**: User's golfer picks for the pool

## Tech Stack & Dependencies

### Core Technologies
- **Ruby**: 3.2.1
- **Rails**: 7.0.4+
- **Database**: MySQL 8 (via Docker)
- **Web Server**: Puma
- **Frontend**: Hotwire (Turbo + Stimulus), Importmap

### Key Gems
- **devise**: User authentication and authorization
- **bcrypt**: Password encryption
- **rspec/rspec-rails**: Testing framework
- **rswag**: API documentation (Swagger/OpenAPI)
- **standard**: Ruby style guide and linter (wraps RuboCop)
- **capybara/selenium-webdriver**: System/integration testing

### Development Tools
- **Docker & Docker Compose**: Containerized development environment
- **RuboCop**: Code quality and style checking (via standard gem)
- **RSpec**: Test framework (both spec/ and test/ directories exist)

## Codebase Structure

```
masters-pool-app/
├── app/
│   ├── assets/           # Stylesheets, images, fonts
│   ├── channels/         # Action Cable websocket channels
│   ├── controllers/      # Request handlers
│   │   ├── application_controller.rb
│   │   ├── golfers_controller.rb
│   │   ├── flights_controller.rb
│   │   ├── leaderboards_controller.rb
│   │   └── user_submission_controller.rb
│   ├── helpers/          # View helpers
│   ├── javascript/       # Stimulus controllers and JS
│   ├── jobs/             # Background jobs (ActiveJob)
│   ├── mailers/          # Email templates and mailers
│   ├── models/           # ActiveRecord models
│   │   ├── golfer.rb    # Primary key: player_id
│   │   ├── user.rb      # Devise authentication
│   │   ├── flight.rb    # Golfer groupings
│   │   ├── leaderboard.rb
│   │   └── user_submission.rb
│   └── views/            # ERB templates and partials
│       ├── golfers/
│       ├── flights/
│       ├── leaderboards/
│       └── layouts/
├── bin/                  # Executable scripts
├── config/
│   ├── routes.rb        # Application routes
│   ├── database.yml     # Database configuration
│   └── environments/    # Environment-specific configs
├── db/
│   ├── migrate/         # Database migrations
│   ├── schema.rb        # Current database schema
│   ├── seeds.rb         # Seed data
│   └── mastersPlayerRankings2013.csv
├── lib/
│   └── tasks/           # Custom rake tasks
│       └── create_golfer_rankings_csv.rake
├── spec/                # RSpec tests
│   ├── models/
│   ├── requests/
│   ├── helpers/
│   └── swagger_helper.rb
├── test/                # Minitest tests (legacy)
├── swagger/             # API documentation
├── docker-compose.yml   # Docker services configuration
├── Dockerfile           # Container image definition
├── Gemfile              # Ruby dependencies
├── Makefile             # Development task shortcuts
├── .rubocop.yml         # Code style configuration
└── .ruby-version        # Ruby version specification
```

## Database Schema & Domain Model

### Tables & Relationships

**golfers** (Primary Key: `player_id`)
- Fields: `name`, `world_ranking`
- Relationships:
  - `has_many :leaderboards`
  - `has_and_belongs_to_many :flights`

**users**
- Fields: `username`, `firstname`, `lastname`, `email`, `encrypted_password`
- Authentication: Devise (database_authenticatable, registerable, recoverable, rememberable, validatable, lockable)
- Note: Contains both `password_digest` and `encrypted_password` (migration artifact)

**flights**
- Fields: `name`
- Purpose: Group golfers by ranking tiers (e.g., "Flight A", "Flight B")
- Relationships:
  - `has_and_belongs_to_many :golfers`

**flights_golfers** (Join Table)
- Fields: `golfer_id`, `flight_id`
- Indexed on both directions

**leaderboards**
- Fields: `golfer_id`, `year`, `position`, `round_one`, `round_two`, `round_three`, `round_four`, `total`, `earnings`
- Tracks tournament results by year
- Relationships:
  - `belongs_to :golfer`

**user_submissions**
- Fields: `user_id`, `golfer_id`
- Tracks user's golfer picks
- Relationships:
  - `belongs_to :user`
  - `belongs_to :golfer`

## Development Workflow

### Docker-First Development

This project is designed for Docker-based development. The standard workflow is:

1. **Initial Setup**: `make clean_build`
2. **Start Development**: `make up`
3. **Stop Services**: `make down`

### Local Development (Alternative)

For non-Docker development:
1. `bundle install`
2. `rails db:create`
3. `rails db:migrate`
4. `rails server`

Note: MySQL configuration may require additional setup. See mysql2 gem documentation if issues arise.

### Git Workflow

Based on recent commits, the project uses:
- **Feature branches** with descriptive names
- **Pull requests** for merging (numbered PRs in commit history)
- **Commit messages** that reference issue/PR numbers
- **Branch naming**: Standard format appears to be descriptive names or issue numbers

## Common Development Tasks

### Makefile Commands

```bash
make clean_build    # Full rebuild: destroy containers, build, setup DB, start
make build          # Build Docker containers
make up             # Start all containers (web on port 3001)
make down           # Stop all containers
make db_setup       # Run migrations and seed data
make db_migrate     # Run pending migrations
make db_seed        # Load seed data
make db_sh          # Open MySQL shell in container
make web_sh         # Open shell in web container
make app_destroy    # WARNING: Destroys all containers, images, volumes
```

### Database Management

```bash
# In Docker
make db_migrate
make db_seed

# Locally
rails db:migrate
rails db:seed
```

### Running Tests

```bash
# RSpec (primary test framework)
docker compose run web rspec

# Or locally
bundle exec rspec

# Run specific test
rspec spec/models/golfer_spec.rb
```

### Code Quality

```bash
# Run standard (RuboCop wrapper)
bundle exec standardrb

# Auto-fix issues
bundle exec standardrb --fix
```

### Custom Rake Tasks

```bash
# Generate golfer rankings CSV from source data
rails create_golfer_csv
```

## API Documentation

The application uses **rswag** for API documentation:
- **Swagger UI**: Available at `/api-docs`
- **API Specs**: Defined in `spec/requests/` with swagger annotations
- **Helper**: `spec/swagger_helper.rb` configures OpenAPI schema

## Routes & Controllers

### Key Routes

```ruby
# Authentication (Devise)
devise_for :users

# Resources
resources :users
resources :golfers

# Custom endpoints
GET  /leaderboards                    # leaderboards#index
POST /leaderboards/single_entry      # leaderboards#single_entry
POST /golfers/create                 # golfers#create
GET  /flights                        # flights#index
```

### API Style

- Mix of RESTful resources and custom actions
- JSON responses available for golfers (via jbuilder)
- Uses standard Rails conventions

## Code Style & Conventions

### RuboCop Configuration

- Uses **GitLab Style Guide** as base (`.rubocop.yml`)
- Excludes: vendor, node_modules, db/schema.rb, tmp, bin
- Target Rails Version: 6.0
- Configured for Ruby 3.x

### Rails Conventions

1. **Models**: Inherit from `ApplicationRecord`
2. **Controllers**: Inherit from `ApplicationController`
3. **Primary Keys**: Most models use `id`, but `Golfer` uses `player_id`
4. **Associations**: Use `has_many`, `has_and_belongs_to_many` appropriately
5. **Authentication**: Leverage Devise modules, don't reinvent

### View Conventions

- **ERB templates** with partials (underscore prefix)
- **JSON builders** for API responses (`.json.jbuilder`)
- **Helpers** for view logic (separate concerns)

## Testing Strategy

### Test Organization

- **Primary Framework**: RSpec (in `spec/`)
- **Legacy Tests**: Minitest (in `test/` - may be outdated)
- **Integration Tests**: Swagger/rswag specs in `spec/requests/`
- **System Tests**: Capybara + Selenium for browser testing

### Running Tests

```bash
# All specs
docker compose run web rspec

# Specific directory
docker compose run web rspec spec/models

# With documentation format
docker compose run web rspec --format documentation

# Generate swagger docs from specs
docker compose run web rake rswag:specs:swaggerize
```

## Docker Environment

### Services

**web** (Rails application)
- Platform: linux/x86_64
- Port: 3001 → 3000 (host:container)
- Depends on: db
- Volume: Current directory mounted to `/app`
- Environment:
  - DB_USER=root
  - DB_NAME=mpooldev
  - DB_PASSWORD=password
  - DB_HOST=db

**db** (MySQL)
- Image: mysql:latest
- Port: 3307 → 3306
- Volume: Persistent storage in `app_db` volume
- Init script: `db/init.sql` (if exists)

### Dockerfile

- Base: `ruby:3.2.1-alpine3.17`
- Includes: Node.js, Yarn, MySQL client
- Bundler: 2.4.7
- Working directory: `/app`

## Key Conventions for AI Assistants

### When Modifying Code

1. **Read Before Changing**: Always read existing files before suggesting modifications
2. **Follow Existing Patterns**: Match the style and structure of existing code
3. **Custom Primary Keys**: Remember `Golfer` uses `player_id`, not `id`
4. **Authentication**: Use Devise patterns, don't implement custom auth
5. **Database Changes**: Always create migrations, never modify `schema.rb` directly
6. **Test Coverage**: Add/update specs for new features
7. **API Documentation**: Update swagger specs when changing API endpoints

### When Adding Features

1. **Model Changes**:
   - Create migration first
   - Add associations in model
   - Update specs

2. **Controllers**:
   - Follow RESTful conventions where possible
   - Add custom actions to routes.rb
   - Return appropriate status codes

3. **Views**:
   - Create partials for reusable components
   - Use helpers for complex view logic
   - Provide both HTML and JSON responses where needed

4. **Testing**:
   - Add request specs for new endpoints
   - Update swagger documentation
   - Add model specs for validations/associations

### Common Gotchas

1. **Database**: Uses MySQL, not SQLite3 (despite Gemfile listing sqlite3)
2. **Ports**: Web accessible on port 3001, not default 3000
3. **Authentication**: Mix of password_digest and Devise (technical debt)
4. **Test Frameworks**: Both RSpec and Minitest present (prefer RSpec)
5. **PID Files**: If server won't start, delete `tmp/pids/server.pid`

### File Paths to Remember

- **Routes**: `config/routes.rb`
- **Schema**: `db/schema.rb` (read-only, generated)
- **Migrations**: `db/migrate/`
- **Seeds**: `db/seeds.rb`
- **Models**: `app/models/`
- **Controllers**: `app/controllers/`
- **Views**: `app/views/[resource]/`
- **Specs**: `spec/[type]/`
- **Docker**: `docker-compose.yml` and `Dockerfile`
- **Config**: `config/database.yml`, `config/environments/`

## Debugging & Troubleshooting

### Common Issues

**Server Won't Start**
```bash
# Remove stale PID file
rm tmp/pids/server.pid
```

**Database Connection Errors**
```bash
# Check MySQL is running
docker compose ps

# Restart database
docker compose restart db

# Check logs
docker compose logs db
```

**Migration Issues**
```bash
# Check migration status
docker compose run web rails db:migrate:status

# Rollback if needed
docker compose run web rails db:rollback

# Reset database (CAUTION: destroys data)
docker compose run web rails db:reset
```

**Container Issues**
```bash
# View logs
docker compose logs web
docker compose logs db

# Rebuild from scratch
make clean_build
```

### Accessing Containers

```bash
# Rails console in Docker
docker compose run web rails console

# Web container shell
make web_sh

# Database shell
make db_sh
```

## Recent Development History

Based on recent commits, the project has been:
- Adding Devise authentication (PR #26)
- Creating flight/golfer associations (PR #21, #25)
- Refining Docker setup (PR #18, #16)
- Adding rake tasks for data import (PR #13)
- Implementing code quality tools (standard gem)

## Additional Resources

- **Rails Guides**: https://guides.rubyonrails.org/
- **Devise Documentation**: https://github.com/heartcombo/devise
- **RSwag**: https://github.com/rswag/rswag
- **Standard Ruby**: https://github.com/testdouble/standard
- **MySQL2 Gem**: https://github.com/brianmario/mysql2

---

*Last Updated: 2025-11-24*
*Generated for AI Assistant Context*

.DEFAULT_GOAL := help

# Variables
LAMBDA_DIR     = .
BINARY_NAME    = bin/bootstrap
ZIP_NAME       = dist/function.zip
BUILD_OS       = linux
BUILD_ARCH     = amd64
MAIN_FILE=main.go

VERSION=$(shell git describe --tags --always --dirty)
TEST_PATH=./internal/...
TEST_COVERAGE_FILE_NAME=coverage.out
MIGRATION_PATH = internal/infrastructure/database/migrations
DB_URL = postgres://postgres:postgres@localhost:5432/fastfood_10soat_g18_tc2?sslmode=disable
LAMBDA_INPUT_FILE=test/data/api_gateway_proxy_request_event_payload.json

# Go commands
AWSLAMBDARPCCMD=awslambdarpc
GOCMD=go
GOBUILD=$(GOCMD) build
GORUN=$(GOCMD) $MAIN_FILE
GOTEST=ENVIRONMENT=test $(GOCMD) test
GOCLEAN=$(GOCMD) clean
GOVET=$(GOCMD) vet
GOFMT=$(GOCMD) fmt
GOTIDY=$(GOCMD) mod tidy

# Looks at comments using ## on targets and uses them to produce a help output.
.PHONY: help
help: ALIGN=22
help: ## Print this message
	@echo "Usage: make <command>"
	@awk -F '::? .*## ' -- "/^[^':]+::? .*## /"' { printf "  make '$$(tput bold)'%-$(ALIGN)s'$$(tput sgr0)' - %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: fmt
fmt: ## Format the code
	@echo  "🟢 Formatting the code..."
	$(GOCMD) fmt ./...

.PHONY: build
build: fmt ## Build the application
	@echo  "🟢 Building the application..."
	#$(GOBUILD) -v -gcflags='all=-N -l' -o bin/$(APP_NAME) $(MAIN_FILE)
	GOOS=$(BUILD_OS) GOARCH=$(BUILD_ARCH) $(GOBUILD) -ldflags="-s -w" -o $(LAMBDA_DIR)/$(BINARY_NAME) $(LAMBDA_DIR)/main.go

# 📦 Package the binary into a .zip file for Lambda deployment
.PHONY: package
package: build
	@echo "📦 Packaging Lambda binary into zip..."
	mkdir -p ./dist
	zip -j $(LAMBDA_DIR)/$(ZIP_NAME) $(LAMBDA_DIR)/$(BINARY_NAME)

.PHONY: run
run: build run-db ## Run the application
	@echo  "🟢 Running the application..."
	awslambdarpc -a localhost:3300 -d $LAMBDA_INPUT_FILE

.PHONY: run-db
run-db: ## Run the database
	@echo  "🟢 Running the database..."
	docker-compose up -d db dbadmin

.PHONY: stop
stop: ## Stop the application
	@echo  "🔴 Stopping the application..."
	docker-compose down	

.PHONY: stop-db
stop-db: ## Stop the database
	@echo  "🔴 Stopping the database..."
	docker-compose down db dbadmin

.PHONY: run-air
run-air: build ## Run the application with Air
	@echo  "🟢 Running the application with Air..."
	@go run github.com/air-verse/air@v1.61.7 -c air.toml

.PHONY: test
test: lint ## Run tests
	@echo  "🟢 Running tests..."
	@$(GOFMT) ./...
	@$(GOVET) ./...
	@$(GOTIDY)
	$(GOTEST) $(TEST_PATH) -race -v

.PHONY: coverage
coverage: ## Run tests with coverage
	@echo  "🟢 Running tests with coverage..."
# remove files that are not meant to be tested
	$(GOTEST) $(TEST_PATH) -coverprofile=$(TEST_COVERAGE_FILE_NAME).tmp
	@cat $(TEST_COVERAGE_FILE_NAME).tmp | grep -v "_mock.go" | grep -v "_request.go" | grep -v "_response.go" \
	| grep -v "_gateway.go" | grep -v "_datasource.go" | grep -v "_presenter.go" | grep -v "middleware" \
	| grep -v "config" | grep -v "route" | grep -v "util" | grep -v "database" \
	| grep -v "server" | grep -v "logger" | grep -v "httpclient" > $(TEST_COVERAGE_FILE_NAME)
	@rm $(TEST_COVERAGE_FILE_NAME).tmp
	$(GOCMD) tool cover -html=$(TEST_COVERAGE_FILE_NAME)

.PHONY: clean
clean: ## Clean up binaries and coverage files
	@echo "🔴 Cleaning up..."
	$(GOCLEAN)
	rm -f $(APP_NAME)
	rm -f $(TEST_COVERAGE_FILE_NAME)
	rm -f $(LAMBDA_DIR)/$(BINARY_NAME) $(LAMBDA_DIR)/$(ZIP_NAME)

.PHONY: mock
mock: ## Generate mocks
	@echo  "🟢 Generating mocks..."
# romove mocks files
	@rm -rf internal/core/port/mocks/*
# loop through all files in the port directory and generate mocks
	@for file in internal/core/port/*.go; do \
		go run go.uber.org/mock/mockgen@v0.5.0 -source=$$file -destination=internal/core/port/mocks/`basename $$file _port.go`_mock.go; \
	done

.PHONY: lint
lint: ## Run linter
	@echo  "🟢 Running linter..."
	@go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.64.7 run --out-format colored-line-number

.PHONY: migrate-create
migrate-create: ## Create new migration, usage example: make migrate-create name=create_table_products
	@echo  "🟢 Creating new migration..."
# if name is not passed, required argument
ifndef name
	$(error name is not set, usage example: make migrate-create name=create_table_products)
endif
	migrate create -ext sql -dir ${MIGRATION_PATH} -seq $(name)

.PHONY: migrate-up
migrate-up: ## Run migrations
	@echo  "🟢 Running migrations..."
	migrate -path ${MIGRATION_PATH} -database "${DB_URL}" -verbose up

.PHONY: migrate-down
migrate-down: ## Roll back migrations
	@echo  "🔴 Rolling back migrations..."
	migrate -path ${MIGRATION_PATH} -database "${DB_URL}" -verbose down

.PHONY: install
install: ## Install dependencies
	@echo  "🟢 Installing dependencies..."
	go mod download
	@go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@v4.18.2

.PHONY: docker-build
docker-build: ## Build Docker image
	@echo  "🟢 Building Docker image..."
	docker build --platform linux/amd64 -t $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_APP):$(VERSION) .
	docker tag $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_APP):$(VERSION) $(DOCKER_REGISTRY)/$(APP_NAME):latest

.PHONY: docker-push
docker-push: ## Push Docker image
	@echo  "🟢 Pushing Docker image..."
	docker push $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_APP):$(VERSION)
	docker push $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_APP):latest


.PHONY: docker-build-mockserver
docker-build-mockserver: ## Build Docker image
	@echo  "🟢 Building Docker mock server image..."
	docker build --platform linux/amd64 -t $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_MOCK_SERVER_APP):$(VERSION) -f Dockerfile.mockserver .
	docker tag $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_MOCK_SERVER_APP):$(VERSION) $(DOCKER_REGISTRY_MOCK_SERVER_APP)/$(APP_NAME):latest

.PHONY: docker-push-mockserver
docker-push-mockserver: ## Push Docker image
	@echo  "🟢 Pushing Docker mock server image..."
	docker push $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_MOCK_SERVER_APP):$(VERSION)
	docker push $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_MOCK_SERVER_APP):latest

.PHONY: compose-build
compose-build: ## Build the application with Docker Compose
	@echo "🟢 Building the application..."
	docker compose build

.PHONY: compose-up
compose-up: ## Start development environment with Docker Compose
	@echo  "🟢 Starting development environment..."
	docker compose pull
	docker-compose up -d --wait --build

.PHONY: compose-down
compose-down: ## Stop development environment with Docker Compose
	@echo  "🔴 Stopping development environment..."
	docker-compose down

.PHONY: compose-clean
compose-clean: ## Clean the application with Docker Compose, removing volumes and images
	@echo "🔴 Cleaning the application..."
	docker compose down --volumes --rmi all

.PHONY: scan
scan: ## Run security scan
	@echo  "🟢 Running security scan..."
	@go run golang.org/x/vuln/cmd/govulncheck@v1.1.4 -show verbose ./...
	@go run github.com/aquasecurity/trivy/cmd/trivy@latest image --severity HIGH,CRITICAL $(DOCKER_REGISTRY)/$(DOCKER_REGISTRY_APP):latest

.PHONY: new-branch
new-branch: ## Create new branch
	@echo "🟢 Creating new branch..."
	./scripts/new-branch.sh -c

.PHONY: pull-request
pull-request: ## Create pull request
	@echo "🟢 Creating pull request..."
	./scripts/pull-request.sh

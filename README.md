# Lambda Authentication Service

This project implements a serverless authentication service using Go, Clean Architecture, and AWS Lambda. The service receives customer credentials, validates them, and returns a signed JWT token upon successful authentication. The architecture enables scalability, maintainability, and testability.

---

## 📁 Folder Structure
```bash
├── Dockerfile
├── Makefile
├── README.md
├── bootstrap
├── compose.yml
├── docs/
│ └── architecture.drawio
├── go.mod
├── go.sum
├── internal/
│ ├── adapter/
│ │ ├── controller/
│ │ │ └── customer_controller.go
│ │ ├── gateway/
│ │ │ └── customer_gateway.go
│ │ └── presenter/
│ │ ├── customer_jwt_token_presenter.go
│ │ ├── customer_jwt_token_presenter_test.go
│ │ └── jwt_response.go
│ ├── core/
│ │ ├── domain/
│ │ │ ├── entity/
│ │ │ │ └── customer_entity.go
│ │ │ └── errors.go
│ │ ├── dto/
│ │ │ ├── customer_dto.go
│ │ │ └── presenter_dto.go
│ │ ├── port/
│ │ │ ├── authentication_port.go
│ │ │ ├── customer_port.go
│ │ │ ├── mocks/
│ │ │ │ ├── authentication_mock.go
│ │ │ │ ├── customer_mock.go
│ │ │ │ └── presenter_mock.go
│ │ │ └── presenter_port.go
│ │ └── usecase/
│ │ ├── customer_usecase.go
│ │ └── customer_usecase_test.go
│ └── infrastructure/
│ ├── aws/
│ │ └── lambda/
│ │ ├── golden/
│ │ │ └── success_response.golden
│ │ ├── lambda.go
│ │ ├── lambda_test.go
│ │ ├── request/
│ │ │ └── customer_request.go
│ │ └── response/
│ │ ├── error_response.go
│ │ └── response.go
│ ├── config/
│ │ └── config.go
│ ├── database/
│ │ └── postgres.go
│ ├── datasource/
│ │ └── customer_datasource.go
│ ├── logger/
│ │ ├── logger.go
│ │ └── pretty_handler.go
│ └── service/
│ └── jwt_service.go
├── main.go
├── terraform/
│ ├── api-gateway.tf
│ ├── iam.tf
│ ├── lambda.tf
│ ├── locals.tf
│ ├── main.tf
│ └── vars.tf
└── test/
└── fixture/
├── customer_fixture.go
└── customer_request.json


```
---

## 🚀 Features

- Customer authentication via email and password
- Secure JWT generation for authenticated sessions
- Clean Architecture separation (domain, use cases, adapters, infrastructure)
- Unit tests with testify and golden file responses
- Error response standardization
- Environment-based configuration
- Terraform for AWS Lambda, API Gateway, IAM provisioning
- 

---

## 🔧 Technologies

- **Go**
- **AWS Lambda**
- **Terraform**
- **Docker**
- **GORM**
- **Testify**
- **JWT**
- **Gin** (for local/test servers)
- **Makefile** for automation
- **Structured logging**

---

## ⚙️ Getting Started

### Prerequisites

- Go 1.19+
- Docker & Docker Compose
- AWS CLI
- Terraform
- 

### Local Development

1. Clone the repository:
```bash
   git clone https://github.com/yourorg/lambda-auth-service.git
   cd lambda-auth-service
```

2. Create your environment variables:
```shell
cp .env.example .env
# Edit .env as needed 
```

3. Install dependencies:

```shell
make install
```

4. Initialize lambda to receive requests:

```shell
# Starts database
make compose-up
# Starts lambda
make start-lambda
```

5. Trigger lambda events
```shell
make trigger-lambda 
```

6. Run tests
```shell
make test 
```

7. View coverage:
```shell
 make coverage
```
## 📝 Authentication API

## 🏗️ Deployment

```bash
#build application for lambda
GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o bootstrap main.go
```
 
## 📈 Testing
Unit tests: make test
Coverage: make coverage
Golden files for output validation are found in internal/infrastructure/aws/lambda/golden/.

## 🧩 Architecture
The project follows Clean Architecture, dividing source code into distinct layers: Domain, UseCases, Adapters, and Infrastructure. See docs/architecture.drawio for the full diagram.

## 👏 Contributing
Fork the repository and create your branch via make new-branch
Run tests before PR (make test)
Ensure code style with make lint
Follow Conventional Commits for commit messages

## 🙏 Support
For issues, open a GitHub issue in this repository.


## 📚 Docs
- [Deploy Go AWS lambda function using Terraform](https://www.thedevbook.com/deploy-go-aws-lambda-function-using-terraform/)
- [How to use terraform variables](https://spacelift.io/blog/how-to-use-terraform-variables)
- [Best practices writing lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [Code best practices for Go Lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html#go-best-practices)
- [Running and debugging lambda locally](https://medium.com/nagoya-foundation/running-and-debugging-go-lambda-functions-locally-156893e4ed0d)

## 📄 License
MIT License
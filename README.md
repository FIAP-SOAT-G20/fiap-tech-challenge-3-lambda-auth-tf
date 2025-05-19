# Lambda Authentication Service

This project implements a serverless authentication service using Go, Clean Architecture, AWS Lambda and AWS API Gateway. The service receives customer credentials, validates them, and returns a signed JWT token upon successful authentication. The architecture enables scalability, maintainability, and testability.

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
│ ├── main.tf
│ ├── providers.tf
│ ├── modules/
│ │   ├── apigateway/
│ │   │   ├── apigateway.tf
│ │   │   ├── deployment.tf
│ │   │   ├── lambda-integration.tf
│ │   │   ├── lambda-permission.tf
│ │   │   ├── stage.tf
│ │   │   └── vars.tf
│ │   └── lambda/
│ │       ├── iam.tf
│ │       ├── lambda.tf
│ │       ├── locals.tf
│ │       ├── output.tf
│ │       ├── s3.tf
│ │       ├── ssm.tf
│ │       └── vars.tf
│ └── test/
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


---

## 🔧 Technologies

- **Go**
- **AWS Lambda**
- **Terraform**
- **Docker**
- **Docker Compose**
- **GORM**
- **Testify**
- **JWT**
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

Deployment is automated via a **GitHub Actions workflow**. When changes are pushed to the main branch (or as configured in your workflow), the pipeline will build and deploy the Lambda function and related infrastructure using Terraform.

**Prerequisite:**
Before running `terraform plan` or `terraform apply` (either locally or via CI), ensure that all variables defined in `terraform/modules/lambda/ssm.tf` are created and initialized in your AWS environment. These variables are required for successful provisioning and configuration of the Lambda function and related resources.

Manual build example (for local reference):


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
- [How to Create API Gateway Using Terraform & AWS Lambda](https://spacelift.io/blog/terraform-api-gateway)
- [How to use a resource created in another module](https://discuss.hashicorp.com/t/how-to-use-a-resource-created-in-another-module/19032/3)

## 📄 License
MIT License
package lambda

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/adapter/controller"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/adapter/gateway"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/adapter/presenter"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/core/usecase"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/infrastructure/aws/lambda/request"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/infrastructure/aws/lambda/response"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/infrastructure/config"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/infrastructure/database"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/infrastructure/datasource"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/infrastructure/logger"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/infrastructure/service"
	"github.com/aws/aws-lambda-go/events"
	"log"

	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/core/port"
	"github.com/aws/aws-lambda-go/lambda"
)

var customerDataSource port.CustomerDataSource
var customerGateway port.CustomerGateway
var customerUseCase port.CustomerUseCase
var customerController port.CustomerController
var pr port.Presenter

// init function is called in a lambda cold start. So, at this moment is initialized
// all structures and also the database connection
func init() {
	fmt.Println("Initializing lambda presenter")
	cfg := config.LoadConfig()
	l := logger.NewLogger(cfg)

	if cfg.Environment == "test" {
		return
	}

	db, err := database.NewPostgresConnection(cfg, l)
	if err != nil {
		panic(err)
	}
	jwtService := service.NewJWTService(cfg)
	customerDataSource = datasource.NewCustomerDataSource(*db)
	customerGateway = gateway.NewCustomerGateway(customerDataSource)
	customerUseCase = usecase.NewCustomerUseCase(customerGateway)
	customerController = controller.NewCustomerController(customerUseCase)
	pr = presenter.NewCustomerJwtTokenPresenter(jwtService)
}

// StartLambda is the function that tells lambda which function should be call to start lambda.
func StartLambda() {
	fmt.Println("Starting lambda")
	lambda.Start(handleRequest)
}

// handleRequest responsible to handle lambda events
func handleRequest(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Println("Starting lambda handler")
	var customerRequest request.CustomerRequest
	err := json.Unmarshal([]byte(req.Body), &customerRequest)
	if err != nil {
		return response.NewAPIGatewayProxyResponseError(err), err
	}
	customerInput := customerRequest.ToGetCustomerInput()
	resp, err := customerController.Get(ctx, pr, customerInput)
	if err != nil {
		log.Printf("Failed to get customer: %v", err)
		return response.NewAPIGatewayProxyResponseError(err), err
	}

	return response.NewAPIGatewayProxyResponse(resp), nil
}

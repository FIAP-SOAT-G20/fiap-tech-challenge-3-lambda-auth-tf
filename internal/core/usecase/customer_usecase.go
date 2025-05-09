package usecase

import (
	"context"

	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/core/domain"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/core/domain/entity"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/core/dto"
	"github.com/FIAP-SOAT-G20/fiap-tech-challenge-3-lambda-auth-tf/internal/core/port"
)

type customerUseCase struct {
	gateway port.CustomerGateway
}

// NewCustomerUseCase creates a new CreateCustomerUseCase
func NewCustomerUseCase(gateway port.CustomerGateway) port.CustomerUseCase {
	return &customerUseCase{gateway}
}

// Get return a customer by his CPF
func (uc *customerUseCase) Get(ctx context.Context, i dto.GetCustomerInput) (*entity.Customer, error) {
	if i.CPF == "" {
		return nil, domain.NewInvalidInputError("cpf is required")
	}

	customers, err := uc.gateway.FindOne(ctx, i.CPF)

	if err != nil {
		return nil, domain.NewInternalError(err)
	}

	if customers == nil {
		return nil, domain.NewNotFoundError("customer not found")
	}

	return customers, nil
}

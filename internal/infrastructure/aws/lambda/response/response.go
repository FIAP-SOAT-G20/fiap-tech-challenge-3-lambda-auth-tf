package response

import (
	"github.com/aws/aws-lambda-go/events"
	"net/http"
)

func NewAPIGatewayProxyResponse(data []byte) events.APIGatewayProxyResponse {
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       string(data),
	}
}

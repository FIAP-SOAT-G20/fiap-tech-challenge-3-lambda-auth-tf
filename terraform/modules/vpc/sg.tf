resource "aws_security_group" "lambda_auth_postgres_sg" {
  name        = "lambda-auth-postgres-sg"
  description = "Security group for Lambda"
  vpc_id      = aws_vpc.fastfood_vpc.id
}

resource "aws_security_group_rule" "lambda_auth_postgres_sg_egress" {
  type              = "egress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda_auth_postgres_sg.id
}

resource "aws_security_group_rule" "lambda_auth_postgres_sg_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda_auth_postgres_sg.id
}

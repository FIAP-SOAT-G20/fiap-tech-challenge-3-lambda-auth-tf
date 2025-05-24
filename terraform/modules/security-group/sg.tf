resource "aws_security_group" "fastfood_auth_sg" {
  name        = "fast-food-auth-sg"
  description = "Security group for the Fast Food Auth API"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fast-food-auth-sg"
  }
}
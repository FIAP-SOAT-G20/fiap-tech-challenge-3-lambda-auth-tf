output "fastfood_vpc_subnet_ids" {
  description = "The subnet IDs of the VPC"
  value       = aws_subnet.fastfood_vpc_subnet.*.id
}

output "fastfood_vpc_security_group_id" {
  description = "The security group ID of the VPC"
  value       = aws_security_group.lambda_auth_postgres_sg.id
}

output "fastfood_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.fastfood_vpc.id
} 
# Outputs
output "vpc_id" {
  value = aws_vpc.dev-vpc.id
}

output "public_subnets" {
  value = [aws_subnet.dev-public-subnet.id]
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}

# create VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "dev"
  }
}

# create public subnet
resource "aws_subnet" "dev-public-subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev"
  }
}

# internet gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev"
  }
}

# route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev"
  }
}

# route
resource "aws_route" "name" {
  destination_cidr_block    = "0.0.0.0/0"
  route_table_id            = aws_route_table.public-route-table.id
  gateway_id                = aws_internet_gateway.dev-igw.id
}

#associate with route and public subnet
resource "aws_route_table_association" "public-subnet-rout-table" {
  subnet_id      = aws_subnet.dev-public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

# Create Security Group 
resource "aws_security_group" "ecs-service-sg" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "dev"
  }
}

# ecs cluster
resource "aws_ecs_cluster" "hellocloud-cluster" {
  name = "hellocloud"
  tags = {
    Name = "dev"
  }
}


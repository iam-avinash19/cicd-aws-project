terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "cicd-terraform-state-avinash"
    key    = "cicd-project/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "cicd_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "cicd-vpc"
    Project = "cicd-aws-project"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "cicd_igw" {
  vpc_id = aws_vpc.cicd_vpc.id

  tags = {
    Name    = "cicd-igw"
    Project = "cicd-aws-project"
  }
}

# Public Subnet
resource "aws_subnet" "cicd_subnet" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "cicd-subnet"
    Project = "cicd-aws-project"
  }
}

# Route Table
resource "aws_route_table" "cicd_rt" {
  vpc_id = aws_vpc.cicd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cicd_igw.id
  }

  tags = {
    Name = "cicd-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "cicd_rta" {
  subnet_id      = aws_subnet.cicd_subnet.id
  route_table_id = aws_route_table.cicd_rt.id
}

# Security Group
resource "aws_security_group" "cicd_sg" {
  name        = "cicd-security-group"
  description = "Allow SSH and app traffic"
  vpc_id      = aws_vpc.cicd_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port"
    from_port   = 5000
    to_port     = 5000
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
    Name    = "cicd-sg"
    Project = "cicd-aws-project"
  }
}

# EC2 Instance
resource "aws_instance" "cicd_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.cicd_subnet.id
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu
    docker pull ${var.docker_image}
    docker run -d -p 5000:5000 --name cicd-app --restart always ${var.docker_image}
  EOF

  tags = {
    Name    = "cicd-server"
    Project = "cicd-aws-project"
  }
}
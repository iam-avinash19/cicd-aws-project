variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI for ap-south-1"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "cicd-key"
}

variable "docker_image" {
  description = "Docker Hub image to deploy"
  type        = string
  default     = "avinash197/cicd-app:v1"
}
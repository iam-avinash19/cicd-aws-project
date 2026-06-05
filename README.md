# CI/CD Automation Platform on AWS

![CI/CD Pipeline](https://github.com/iam-avinash19/cicd-aws-project/actions/workflows/deploy.yml/badge.svg)

## Project Overview
A production-grade CI/CD pipeline that automatically builds, tests, and deploys
a containerized Python application to AWS EC2 — triggered by every GitHub push.

## Architecture
Developer → GitHub → GitHub Actions → Docker Hub → AWS EC2

## Tech Stack
- **App:** Python (Flask)
- **Containerization:** Docker
- **CI/CD:** GitHub Actions
- **Infrastructure as Code:** Terraform
- **Cloud:** AWS (EC2, VPC, S3, IAM, CloudWatch)
- **Monitoring:** CloudWatch alarms + SNS email alerts

## What this pipeline does automatically
1. Runs unit tests on every push
2. Builds a Docker image tagged with git commit SHA
3. Pushes image to Docker Hub
4. SSHs into EC2 and deploys new container
5. Runs health check to verify deployment
6. CloudWatch monitors CPU and sends alerts

## Infrastructure created by Terraform
- Custom VPC with public subnet
- Internet Gateway and Route Table
- Security Group (ports 22, 5000)
- t2.micro EC2 instance (free tier)
- S3 bucket for remote Terraform state

## Key Results
- 0 manual deployment steps after initial setup
- Deployment time: under 2 minutes per push
- 99.9% uptime target via health checks and auto-restart
- Remote state management for team collaboration

## Setup Instructions

### Prerequisites
- AWS account with CLI configured
- Docker Hub account
- Terraform installed

### Deploy infrastructure
cd terraform
terraform init
terraform apply

### Trigger pipeline
git add .
git commit -m "your change"
git push

Pipeline runs automatically on GitHub Actions.

## Live Demo
App URL: http://13.206.82.201:5000
Health: http://13.206.82.201/health
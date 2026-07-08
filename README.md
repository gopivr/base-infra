# Base Infrastructure

This repository contains the shared Terraform infrastructure for the AgriFarms platform. It provisions the core AWS foundation required by the application services, including networking, security, load balancing, container infrastructure, IAM, and database resources.

## What this project does

The infrastructure in this repository is designed to provide a reusable base environment for the platform. It includes:

- A VPC with public and private subnets
- Security groups for ALB, ECS, and RDS access
- An Application Load Balancer and listeners
- An ECS cluster and target group
- An ECR repository for container images
- IAM roles and policies for container execution
- An RDS PostgreSQL instance
- Route 53 and ACM integration for domain-based access

## Repository structure

- [infra](infra/) - Terraform root configuration and modules
- [infra/modules](infra/modules/) - Reusable Terraform modules for VPC, subnets, security groups, ALB, ECS, IAM, ECR, Route 53, and RDS
- [doc](doc/) - Additional infrastructure documentation
- [.github/workflows](.github/workflows/) - Deployment automation for environment create/destroy workflows

## Prerequisites

Before deploying this infrastructure, make sure you have:

- Terraform installed
- AWS CLI configured with valid credentials
- An S3 bucket available for Terraform remote state
- The required domain and hosted zone details for Route 53 and ACM

## Required inputs

The Terraform root module expects the following values:

- project
- env
- region
- state_bucket_name
- db_name
- db_username
- db_password
- domain_name
- repo_name
- route53_zone_id

Optional inputs include:

- subject_alternative_names
- tags

## Usage

Navigate to the Terraform root directory and initialize the configuration:

```bash
cd infra
terraform init
```

Create an execution plan:

```bash
terraform plan \
  -var="project=agrifarms" \
  -var="env=prod" \
  -var="region=ap-south-2" \
  -var="state_bucket_name=agri-prod-terraform-s3-state" \
  -var="db_name=agrifarms" \
  -var="db_username=postgres" \
  -var="db_password=your-password" \
  -var="domain_name=example.com" \
  -var="repo_name=agrifarms" \
  -var="route53_zone_id=Z1234567890"
```

Apply the configuration:

```bash
terraform apply
```

## Notes

- Remote state is configured to use an S3 backend.
- This repository sets up the shared infrastructure layer. Application-specific ECS services and task definitions are typically managed separately.
- Review the documentation in [doc/existing-infra.md](doc/existing-infra.md) for a detailed inventory of the resources currently provisioned.

## License

This project is intended for internal platform infrastructure use.

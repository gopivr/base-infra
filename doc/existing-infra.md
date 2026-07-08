# Existing Infrastructure (base-infra)

This document summarizes the Terraform configuration found in `base-infra/infra`.
It lists resources explicitly declared in the Terraform code. Values that are provided via variables or data sources are marked as templated and are not inferred.

---

## 1. Providers & backend

| Item | Details | Notes |
|---|---|---|
| AWS provider | `source = "hashicorp/aws"`, `version = "~> 5.82.2"` | Declared in `modules/state.tf` (required_providers). Provider block in `infra/main.tf` sets `region = var.region` (templated). |
| Region (provider) | `var.region` | Templated variable (see `infra/variable.tf`). |
| Terraform backend | S3
| Bucket | `agri-prod-terraform-s3-state` (explicit in `infra/backend.tf`) |
| Backend key | `infra/terraform.tfstate` (explicit) | 
| Backend region | `ap-south-2` (explicit)
| Encryption | `encrypt = true` (explicit)

Notes: backend S3 bucket is explicitly configured. Provider region is templated via `var.region`.

---

## 2. Networking

| Item | Details | Notes / Templated |
|---|---|---|
| VPC | Resource `aws_vpc.vpc` in `modules/vpc/vpc.tf` | `cidr_block = var.vpc_cidr` (templated; default `10.1.0.0/16` in `modules/vpc/variables.tf`). Tags: `Name = "${var.project}-${var.env}-vpc"`, `Project`, `Environment`.
| Availability Zones | Data: `data.aws_availability_zones.selected` (state = "available") used to create subnets | AZ names come from AWS at apply time (templated via data source).
| Public subnets | `aws_subnet.public_subnet` (one per AZ). CIDR computed: `cidrsubnet(var.vpc_cidr, 4, count.index)` | CIDRs generated from `var.vpc_cidr` (templated). `map_public_ip_on_launch = true`.
| Private subnets | `aws_subnet.private_subnet` (one per AZ). CIDR computed: `cidrsubnet(var.vpc_cidr, 4, count.index + length(data.aws_availability_zones.selected.names))` | CIDRs templated/formula-based.
| Route tables | `aws_route_table.public_subnet_route_table`, `aws_route_table.private_subnet_route_table` | Public route has route to IGW. Associations created for each subnet.
| Internet Gateway | `aws_internet_gateway.public_igw` | Attached to VPC; public route uses this IGW (`aws_route.internet_access`).
| NAT Gateway | None declared (no `aws_nat_gateway` resources found) | If private subnets need outbound NAT, not present in current config.
| DB subnet groups | `aws_db_subnet_group.private_subnet_group`, `aws_db_subnet_group.public_subnet_group` | Use private/public subnets created above.

---

## 3. Compute

| Item | Details | Notes / Templated |
|---|---|---|
| ECS cluster | `aws_ecs_cluster.ecs_cluster` in `modules/ecs-cluster/ecs.tf` | Name: `${var.project}-${var.env}-cluster` (templated). Outputs provided (`ecs_cluster_name`, `ecs_cluster_id`, `ecs_cluster_arn`).
| EC2 instances | None declared (no `aws_instance` resources found)
| Lambda functions | None declared (no `aws_lambda_function` resources found)
| Fargate services / ECS Services | No `aws_ecs_service` or task definitions found in this repo (infrastructure provides cluster and target-group; services likely created per-microservice elsewhere) | Target group and ALB are present to support services.
| ECR repository | `aws_ecr_repository.ecr` in `modules/ecr/main.tf` | Name: `${var.repo_name}-${var.env}-repo` (templated). `force_delete = true`.

---

## 4. Load balancing

| Item | Details | Notes / Templated |
|---|---|---|
| ALB | `aws_lb.public_alb` in `modules/alb/alb.tf` | Name: `${var.project}-${var.env}-alb` (templated). `internal = false`, type `application`. Uses `security_groups = [var.alb_sg_id]` and `subnets = var.public_subnet_ids` (both templated inputs).
| Listeners | `aws_lb_listener.https_listener` (port 443) and `aws_lb_listener.http_listener` (port 80) in `modules/alb-listener/alb-listener.tf` | HTTPS listener uses `certificate_arn = var.certificate_arn` (templated) and forwards to `var.ecs_target_group_arn` (templated). HTTP listener redirects to HTTPS.
| Target group | `aws_lb_target_group.ecs_target_group` in `modules/ecs-target-groups/ecs-target-groups.tf` | Name: `${var.project}-${var.env}-ecs-tg` (templated). Port 8080, protocol HTTP, `target_type = "ip"`. Health check path `/` and matcher `200`.

---

## 5. Data layer

| Item | Details | Notes / Templated |
|---|---|---|
| RDS | `aws_db_instance.postgres` in `modules/data-source/data-source.tf` | identifier `${var.project}-${var.env}-database` (templated). Engine `postgres`, version `17.4`. Instance class `db.t4g.micro`. `db_name`, `username`, `password` use `var.db_name`, `var.db_username`, `var.db_password` (templated). `db_subnet_group_name = var.public_subnet_group_name`. `vpc_security_group_ids = [var.rds_sg_id, var.ecs_cluster_sg_id]`. `publicly_accessible = true`.
| DynamoDB | None declared
| S3 buckets | No S3 bucket resources declared in code (state S3 bucket referenced in backend is external/explicit) | Backend bucket `agri-prod-terraform-s3-state` is not created in this repo; it's assumed to exist.
| ElastiCache | None declared

---

## 6. IAM

| Item | Details | Notes / Templated |
|---|---|---|
| IAM Role (ECS Task Execution) | `aws_iam_role.ecsTaskExecutionRole` in `modules/iam-roles/iam-roles.tf` | Name: `${var.project}-${var.env}-execution-task-role` (templated). Assume role policy from `data.aws_iam_policy_document.assume_role_policy` (service principal `ecs-tasks.amazonaws.com`).
| IAM Policies (custom) | `aws_iam_policy.ecr_pullthroughcache_policy` in `modules/iam-policies/iam-polices.tf` | Allows ECR actions on `arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:*` (templated). Tagged with `Name = "${var.project}-${var.env}-ecr-pullthrough-policy"`.
| IAM Role Policy Attachments | Three attachments in `modules/iam-policies/iam-polices.tf` attach:
  - `arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role`
  - `arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy`
  - custom `aws_iam_policy.ecr_pullthroughcache_policy` | Attachments use `role = var.ecs_task_execution_role_name` (templated input referencing `module.iam_roles.ecs_task_execution_role_name` in root module).
| Other IAM policies/roles | There are several commented-out policy resources (Secrets Manager, app autoscaling) in `modules/iam-policies/iam-polices.tf` (not active).

---

## 7. Naming conventions and tagging patterns

| Item | Example | Notes |
|---|---|---|
| Resource Name pattern | VPC: `"${var.project}-${var.env}-vpc"` (see `modules/vpc/vpc.tf`) | Many resources follow `${project}-${env}-<resource>` or `${project}.${env}-<resource>` patterns. Example: ALB `"${var.project}-${var.env}-alb"`, ECR repo `"${var.repo_name}-${var.env}-repo"`, target group `"${var.project}-${var.env}-ecs-tg"`.
| Tag keys | `Project`, `Environment`, `Name` | Most resources set `Project = var.project`, `Environment = var.env`, and `Name` constructed from variables.
| TargetGroup Tag anomaly | In `ecs-target-groups` tags `Name = "${var.project}.${var.env}-ecs-tg"` (dot between project and env) | Slight inconsistency vs. other resources which use hyphen `-`.

Note: project/env driven naming and tagging is used consistently; many runtime values are templated.

---

## 8. Modules being reused and their input variables

A list of modules defined under `infra/modules` and the inputs wired in `infra/main.tf`.

| Module | Source path | Inputs passed from `infra/main.tf` | Module-level variables (high-level) |
|---|---|---|---|
| vpc | `./modules/vpc` | `vpc_cidr = var.vpc_cidr`, `project = var.project`, `env = var.env` | `vpc_cidr`, `project`, `env` (see `modules/vpc/variables.tf`)
| subnets | `./modules/subnets` | `vpc_id = module.vpc.vpc_id`, `project = var.project`, `vpc_cidr = var.vpc_cidr`, `env = var.env` | Uses `data.aws_availability_zones.selected` to build subnets; variables: `vpc_id`, `project`, `vpc_cidr`, `env`.
| security_groups | `./modules/security-groups` | `vpc_id = module.vpc.vpc_id`, `project = var.project`, `env = var.env` | Variables: `vpc_id`, `project`, `env`.
| acm | `./modules/acm` | `domain_name = var.domain_name`, `env = var.env`, `root_zone_id = var.route53_zone_id`, `subject_alternative_names = var.subject_alternative_names` | Variables include `domain_name`, `root_zone_id`, `subject_alternative_names`, `validation_method`.
| ecs_target_groups | `./modules/ecs-target-groups` | `vpc_id = module.vpc.vpc_id`, `project = var.project`, `env = var.env` | Variables: `project`, `vpc_id`, `env`.
| alb | `./modules/alb` | `alb_sg_id = module.security_groups.alb_sg_id`, `project = var.project`, `env = var.env`, `public_subnet_ids = module.subnets.public_subnet_ids` | Variables: `project`, `alb_sg_id`, `public_subnet_ids`, `env`.
| alb_listeners | `./modules/alb-listener` | `alb_arn = module.alb.alb_arn`, `env = var.env`, `certificate_arn = module.acm.certificate_arn`, `ssl_policy = "ELBSecurityPolicy-2016-08"`, `ecs_target_group_arn = module.ecs_target_groups.ecs_target_group_arn` | Variables include `alb_arn`, `certificate_arn`, `ecs_target_group_arn`, `ssl_policy`, `env`.
| route53 | `./modules/route53` | `project = var.project`, `env = var.env`, `domain_name = var.domain_name`, `route53_zone_id = var.route53_zone_id`, `alb_dns_name = module.alb.alb_dns_name`, `alb_zone_id = module.alb.alb_zone_id` | Variables: `alb_dns_name`, `alb_zone_id`, `domain_name`, `route53_zone_id`, `project`, `env`.
| data-source (RDS) | `./modules/data-source` | `db_name = var.db_name`, `db_username = var.db_username`, `db_password = var.db_password`, `project = var.project`, `env = var.env`, `public_subnet_group_name = module.subnets.public_db_subnet_group_name`, `rds_sg_id = module.security_groups.rds_sg_id`, `ecs_cluster_sg_id = module.security_groups.ecs_cluster_sg_id` | Variables include DB credentials and subnet group names.
| ecs-cluster | `./modules/ecs-cluster` | `project = var.project`, `env = var.env` | Variables: `project`, `env`.
| ecr | `./modules/ecr` | `repo_name = var.repo_name`, `tags = var.tags`, `env = var.env` | Variables: `repo_name`, `tags`, `env`.
| iam-roles | `./modules/iam-roles` | `project = var.project`, `region = var.region`, `env = var.env` | Variables: `project`, `region`, `env`.
| iam-policies | `./modules/iam-policies` | `project = var.project`, `region = var.region`, `env = var.env`, `ecs_task_execution_role_name = module.iam_roles.ecs_task_execution_role_name` | Variables: `project`, `region`, `ecs_task_execution_role_name`, `env`.

---

## Notable omissions / things to check

- No NAT gateway or NAT instance resources are present — private subnets currently have no explicit NAT for outbound internet access.
- No ECS services, task definitions, or autoscaling resources are present — the infra provides cluster/ALB/target-group/ECR patterns but microservice-specific ECS service/task definitions are expected to be created per microservice (not in this repo).
- Secrets/SSM integration is commented out in IAM policies — any secret access policies should be reviewed/added when creating a microservice.
- Many values are templated via variables: `project`, `env`, `region`, `domain_name`, `route53_zone_id`, `repo_name`, `db_name`, `db_username`, `db_password`, `subject_alternative_names`, and `certificate_arn` are passed between modules via variables and need to be provided when creating microservice Terraform or invoking this root module.

---

If you want, I can now generate a starter Terraform module (task definition + ecs service + alb target attachment + IAM task role bindings) for the `agrifarm-common-service` that uses the existing ECR, ALB and target-group patterns. Specify environment (`env`), `project`, and any secrets/ports required and I will scaffold it.

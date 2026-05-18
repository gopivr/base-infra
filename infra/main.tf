provider "aws" {
  region = var.region
}

module "route53" {
  source = "./modules/route53"
  project = var.project
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

# VPC
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  project = var.project
}

# Subnets
module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
  project = var.project
  vpc_cidr = var.vpc_cidr
}

# Security Groups
module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
  project = var.project
}

# ALB
module "alb" {
  source = "./modules/alb"
  alb_sg_id = module.security_groups.alb_sg_id
  project = var.project
  public_subnet_ids = module.subnets.public_subnet_ids
}

# ECS Target Groups
module "ecs_target_groups" {
  source = "./modules/ecs-target-groups"
  vpc_id = module.vpc.vpc_id
  project = var.project
}

# ALB Listeners
module "alb_listeners" {
  source = "./modules/alb-listener"
  alb_arn = module.alb.alb_arn
  certificate_arn = module.acm.certificate_arn
  ssl_policy = "ELBSecurityPolicy-2016-08"  # Update as
  ecs_target_group_arn = module.ecs_target_groups.ecs_target_group_arn
}

# Database
module "rds" {
  source = "./modules/data-source"
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  project = var.project
  public_subnet_group_name = module.subnets.public_db_subnet_group_name
  rds_sg_id = module.security_groups.rds_sg_id
  ecs_cluster_sg_id = module.security_groups.ecs_cluster_sg_id
}

# ECS Cluster
module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  project = var.project
}

# ECR
module "ecr" {
  source = "./modules/ecr"
  repo_name = var.repo_name
  tags = var.tags
}

# IAM Roles
module "iam_roles" {
  source = "./modules/iam-roles"
  project = var.project
  region = var.region
}


# IAM Policies
module "iam_policies" {
  source = "./modules/iam-policies"
  project = var.project
  region = var.region
  ecs_task_execution_role_name = module.iam_roles.ecs_task_execution_role_name
}

# ACM
 module "acm" {
   source = "./modules/acm"
   domain_name = var.domain_name
   root_zone_id = module.route53.root_zone_id
   subject_alternative_names = var.subject_alternative_names
 }
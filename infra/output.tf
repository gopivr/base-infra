output "repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_name
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_id
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_arn
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value       = module.iam_roles.ecs_task_execution_role_arn
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  value       = module.iam_roles.ecs_task_execution_role_name
}

output "ecs_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = module.ecs_target_groups.ecs_target_group_arn
}

output "ecs_target_group_name" {
  description = "Name of the ALB Target Group"
  value       = module.ecs_target_groups.ecs_target_group_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = module.subnets.public_subnet_ids
}

output "ecs_cluster_sg_id" {
  description = "Security Group ID for the ECS Cluster"
  value       = module.security_groups.ecs_cluster_sg_id
}

output "root_zone_id" {
  description = "The Route53 hosted zone ID of the root domain"
  value       = module.route53.root_zone_id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = module.alb_listeners.https_listener_arn
}
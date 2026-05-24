variable "project" {
  description = "The project Name where all resources will be launched."
  type = string
}

variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}

variable "region" {
  description = "The region to create resources."
  type = string
}

variable "state_bucket_name" {
  description = "The name of the S3 bucket to store Terraform state."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "db_name" {
  description = "The name of the database snapshot."
  type        = string
}

variable "db_username" {
  description = "The username for the database."
  type        = string
}

variable "db_password" {
  description = "The password for the database."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the ACM certificate."
  type        = string
}

variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "tags" {
  description = "Optional tags for the repository"
  type        = map(string)
  default     = {}
}

variable "subject_alternative_names" {
  description = "List of SAN domains"
  type        = list(string)
  default     = []
}

variable "route53_zone_id" {
  description = "The ID of the Route53 hosted zone."
  type        = string
}
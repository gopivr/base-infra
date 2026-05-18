variable "project" {
  description = "Project name to be used in resource naming and tagging"
  type        = string
}

variable "db_name" {
  description = "Initial database name to create"
  type        = string
}

variable "public_subnet_group_name" {
  description = "Name of the DB subnet group (public or private depending on setup)"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "doyomo"
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "Storage size in GB for the RDS instance"
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "Postgres engine version"
  type        = string
  default     = "17.4"
}

variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t4g.micro"
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible"
  type        = bool
  default     = true
}

variable "rds_sg_id" {
  description = "Security group for RDS instance"
  type        = any
}

variable "ecs_cluster_sg_id" {
  description = "Security group for ECS cluster"
  type        = any
}
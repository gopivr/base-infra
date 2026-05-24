variable "project" {
  description = "Project name for tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}
variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
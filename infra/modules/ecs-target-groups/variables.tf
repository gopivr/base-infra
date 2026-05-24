variable "project" {
  description = "Project name for tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}
variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
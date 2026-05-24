variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "project" {
  description = "Project name used in resource naming and tagging"
  type        = string
}

variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
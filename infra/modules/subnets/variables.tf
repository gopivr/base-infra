variable "project" {
  description = "Project name used in resource naming and tagging"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where subnets and gateways will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "project" {
  description = "Project name to be used in resource naming and tagging"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID to associate with the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}
variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
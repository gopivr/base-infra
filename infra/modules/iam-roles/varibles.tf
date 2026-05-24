variable "project" {
  description = "Project name for tagging resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
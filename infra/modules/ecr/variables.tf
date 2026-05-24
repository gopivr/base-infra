variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "tags" {
  description = "Optional tags for the repository"
  type        = map(string)
  default     = {}
}
variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
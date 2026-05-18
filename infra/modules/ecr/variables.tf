variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "doyomo"
}

variable "tags" {
  description = "Optional tags for the repository"
  type        = map(string)
  default     = {}
}
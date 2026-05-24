variable "domain_name" {
  description = "The primary domain name for the ACM certificate"
  type        = string
}

variable "root_zone_id" {
  description = "The Route53 hosted zone ID for the domain"
  type        = string
}

variable "validation_method" {
  description = "The validation method for the ACM certificate (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}

variable "record_ttl" {
  description = "TTL for DNS validation records"
  type        = number
  default     = 300
}

variable "subject_alternative_names" {
  description = "List of SAN domains"
  type        = list(string)
}
variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
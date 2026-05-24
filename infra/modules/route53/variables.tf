variable "project" {
  description = "Project name used to construct the subdomain"
  type        = string
}
variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB"
  type        = string
}
variable "env" {
  description = "The environment name, defined in environments defined as a environment."
  type = string
}
variable "domain_name" {
  description = "The root domain name (without .com) for Route53"
  type        = string
}
variable "route53_zone_id" {
  description = "The ID of the Route53 hosted zone."
  type        = string
}
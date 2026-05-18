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
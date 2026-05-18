variable "alb_arn" {
  description = "ARN of the Application Load Balancer where listeners will be attached"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for the HTTPS listener"
  type        = string
}

variable "ecs_target_group_arn" {
  description = "ARN of the target group for forwarding traffic"
  type        = string
}

variable "ssl_policy" {
  description = "SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.public_alb.id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.public_alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.public_alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB (useful for Route53 alias)"
  value       = aws_lb.public_alb.zone_id
}

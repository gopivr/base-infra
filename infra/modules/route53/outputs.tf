output "root_zone_id" {
  description = "The Route53 hosted zone ID of the root domain"
  value       = data.aws_route53_zone.root_zone
}
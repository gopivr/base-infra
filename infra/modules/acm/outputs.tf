output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.cert.arn
}

output "certificate_domain_name" {
  description = "The domain name for the ACM certificate"
  value       = aws_acm_certificate.cert.domain_name
}

output "certificate_validation_status" {
  description = "Validation status of the ACM certificate"
  value       = aws_acm_certificate.cert.status
}

output "cert_validation_fqdns" {
  description = "List of FQDNs created for DNS validation"
  value       = [for r in aws_route53_record.cert_validation_record : r.fqdn]
}
data "aws_route53_zone" "root_zone" {
  zone_id = var.route53_zone_id
}

# Subdomain: api.domain.com
resource "aws_route53_record" "api_subdomain" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "api-${var.env}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Subdomain: auth.domain.com
resource "aws_route53_record" "auth_subdomain" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "auth-${var.env}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
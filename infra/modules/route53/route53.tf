resource "aws_route53_zone" "root_zone" {
  name = "doyomo.com"
  lifecycle {
    prevent_destroy = false
  }
}

# Subdomain: api.doyomo.com
resource "aws_route53_record" "api_subdomain" {
  zone_id = aws_route53_zone.root_zone.zone_id
  name    = "api.doyomo.com"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Subdomain: auth.doyomo.com
resource "aws_route53_record" "auth_subdomain" {
  zone_id = aws_route53_zone.root_zone.zone_id
  name    = "auth.doyomo.com"
  type    = "A"
  alias {
    name                   = var.alb_dns_name    # another ALB or same
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
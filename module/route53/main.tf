# Create Route53 Hosted Zone
data "aws_route53_zone" "zone" {
  name         = var.domain
  private_zone = false
}

# Create A Record For Stage Environment
resource "aws_route53_record" "stage" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.stage-domain 
  type    = "A"

  alias {
    name                   = var.stage_lb_dns_name
    zone_id                = var.stage_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Production Environment
resource "aws_route53_record" "production" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.prod-domain 
  type    = "A"

  alias {
    name                   = var.prod_lb_dns_name
    zone_id                = var.prod_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Prometheus
resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.prometheus-domain 
  type    = "A"

  alias {
    name                   = var.prometheus_lb_dns_name
    zone_id                = var.prometheus_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Grafana
resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.grafana-domain 
  type    = "A"

  alias {
    name                   = var.grafana_lb_dns_name
    zone_id                = var.grafana_lb_zone_id
    evaluate_target_health = true
  }
}

# sign your certificate
resource "aws_acm_certificate" "certificate" {
  domain_name       = var.domain
  subject_alternative_names = [var.domain2]
  validation_method = "DNS"

  tags = {
    Environment = "production"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Creating record set in Route53 for Domain Validation
resource "aws_route53_record" "validation-record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = data.aws_route53_zone.zone.zone_id
}
# Creating instruction to validate ACM certificate
resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation-record : record.fqdn]
}
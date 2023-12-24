output "route53-dns-name" {
  value = data.aws_route53_zone.zone.name_servers
}

output "route53_hosted_zone" {
  value = data.aws_route53_zone.zone.zone_id
}

output "sock-cert" {
  value = aws_acm_certificate.certificate.arn
}
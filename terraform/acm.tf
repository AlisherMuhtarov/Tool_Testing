resource "aws_acm_certificate" "app" {
  domain_name       = "virmzi.de"
  validation_method = "DNS"
}

resource "aws_route53_record" "alb_record" {
  zone_id = "Z021882324FAK648HPE4P"
  name    = [aws_acm_certificate.app.domain_validation_options[0].resource_record_name]
  type    = [aws_acm_certificate.app.domain_validation_options[0].resource_record_type]
  records = [aws_acm_certificate.app.domain_validation_options[0].resource_record_value]
  ttl = 300
  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate_validation" "app" {
  certificate_arn         = aws_acm_certificate.app.arn
  validation_record_fqdns = [aws_route53_record.alb_record.fqdn]
}
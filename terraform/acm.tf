resource "aws_acm_certificate" "app" {
  domain_name       = "virmzi.de"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "app_validation" {
  zone_id = "<your_route53_zone_id>"
  name    = "_acme-challenge.virmzi.de"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_acm_certificate_validation.app.validation_record_fqdn]

  depends_on = [aws_acm_certificate_validation.app]
}

resource "aws_acm_certificate_validation" "app" {
  certificate_arn         = aws_acm_certificate.app.arn
  validation_record_fqdns = [aws_route53_record.app_validation.fqdn]
}
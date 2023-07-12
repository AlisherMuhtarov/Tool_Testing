resource "aws_acm_certificate" "app" {
  domain_name       = "virmzi.de"
  validation_method = "DNS"

}

resource "aws_route53_record" "app_validation" {
  zone_id = "Z021882324FAK648HPE4P"
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
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

resource "null_resource" "app_dns_validation" {
  depends_on = [aws_acm_certificate.app, aws_route53_zone.app_zone]

  provisioner "local-exec" {
    command = <<EOT
      aws route53 create-resource-record \
        --hosted-zone-id "${aws_route53_zone.app_zone.zone_id}" \
        --name "_acme-challenge.virmzi.de." \
        --type "CNAME" \
        --ttl 300 \
        --resource-records '[{ "Value": "${aws_acm_certificate.app.domain_validation_options.0.resource_record_name}" }]'
    EOT
  }
}

resource "aws_acm_certificate_validation" "app" {
  certificate_arn         = aws_acm_certificate.app.arn
  validation_record_fqdns = [aws_route53_record.app_validation.fqdn]
}
resource "aws_acm_certificate" "app" {
  domain_name       = "virmzi.de"
  validation_method = "DNS"

}

resource "aws_route53_record" "alb_record" {
  zone_id = "Z021882324FAK648HPE4P"
  name    = "www.virmzi.de"
  type    = "A"
  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}

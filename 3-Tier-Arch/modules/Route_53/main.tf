# ROUTE_53 CONFIGURATION FOR DOMAIN NAME
resource "aws_route53_zone" "cloudgen_hosted_zone" {
  name = var.domain_name
}

# ROUTE_53 RECORD
resource "aws_route53_record" "cloudgen_record" {
  zone_id = aws_route53_zone.cloudgen_hosted_zone.zone_id
  name = "gloudgen-app.${var.domain_name}"
  type = var.record_type


  alias {
    name = var.presentation_layer_lb_dns
    zone_id = var.presentation_layer_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}


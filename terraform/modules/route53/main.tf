resource "aws_route53_record" "with_alias" {
  zone_id = var.host_zone_id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = false
  }
}

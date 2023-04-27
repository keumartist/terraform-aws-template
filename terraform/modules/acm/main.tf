resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    "team" = "devops"
  }

  lifecycle {
    create_before_destroy = true
  }
}

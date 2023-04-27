output "domain_name" {
  value = aws_acm_certificate.this.domain_name
}

output "arn" {
  value = aws_acm_certificate.this.arn
}

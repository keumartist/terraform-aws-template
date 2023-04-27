output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.this.invoke_url
}

output "cloudfront_domain_name" {
  value = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
}

output "cloudfront_zone_id" {
  value = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
}

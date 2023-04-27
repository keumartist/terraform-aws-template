module "api_gateway_from_openapi" {
  source       = "../../modules/api-gateway/rest-api"
  openapi_path = "${path.root}/../../../openapi/users.yaml"

  name        = var.api_gateway_name
  description = "API gateway with openapi, connected to lambda ${var.lambda_function_name}"
  team        = "devops"
  stage_name  = var.stage_name == "" ? "main" : var.stage_name

  lambda_function_name       = var.lambda_function_name
  lambda_function_invoke_arn = module.lambda_for_api_gateway.invoke_arn
  api_key_source             = var.api_key_source == "" ? "HEADER" : var.api_key_source
  aws_region                 = var.aws_region
  lambda_timeout_millis      = var.lambda_timeout_millis

  domain_name         = var.domain_name
  acm_certificate_arn = module.acm_certificate.arn
  # base_path           = var.base_path

  providers = {
    aws = aws
  }
}

module "lambda_for_api_gateway" {
  source                  = "../../modules/lambda"
  lambda_placeholder_path = "${path.root}/../../../placeholders/lambda/index.zip"

  name    = var.lambda_function_name
  handler = "index.handler"
  runtime = var.runtime // "nodejs16.x"
  layer   = []

  providers = {
    aws = aws
  }
}

module "route53_domain" {
  source = "../../modules/route53"

  host_zone_id  = var.host_zone_id
  record_name   = var.domain_name
  record_type   = "A"
  alias_name    = module.api_gateway_from_openapi.cloudfront_domain_name
  alias_zone_id = module.api_gateway_from_openapi.cloudfront_zone_id

  providers = {
    aws = aws
  }
}

module "acm_certificate" {
  source = "../../modules/acm"

  domain_name = var.domain_name

  providers = {
    aws = aws
  }
}

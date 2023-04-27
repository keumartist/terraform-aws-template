resource "aws_api_gateway_rest_api" "api_from_openapi" {
  name        = var.name
  description = var.description

  /// Uncomment this line to use the openapi file
  # body = templatefile(var.openapi_path, {
  #   aws_region            = var.aws_region
  #   lambda_invoke_arn     = var.lambda_function_invoke_arn
  #   lambda_timeout_millis = var.lambda_timeout_millis
  # })


  # api_key_source = var.api_key_source

  tags = {
    "team" = var.team
  }

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.api_from_openapi.id
  parent_id   = aws_api_gateway_rest_api.api_from_openapi.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "this" {
  rest_api_id      = aws_api_gateway_rest_api.api_from_openapi.id
  resource_id      = aws_api_gateway_resource.this.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = aws_api_gateway_rest_api.api_from_openapi.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this.http_method

  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_method" "cors" {
  rest_api_id   = aws_api_gateway_rest_api.api_from_openapi.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors" {
  rest_api_id = aws_api_gateway_rest_api.api_from_openapi.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.cors.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}

resource "aws_api_gateway_method_response" "cors" {
  rest_api_id = aws_api_gateway_rest_api.api_from_openapi.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.cors.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "cors" {
  rest_api_id = aws_api_gateway_rest_api.api_from_openapi.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.cors.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'", # replace with hostname of frontend (CloudFront)
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type, x-api-key, Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, POST, PUT, DELETE'" # remove or add HTTP methods as needed
  }
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.acm_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.api_from_openapi.id
  domain_name = aws_apigatewayv2_domain_name.this.domain_name
  stage       = var.stage_name
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_from_openapi.execution_arn}/*/*" # Replace * with the resource path
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.api_from_openapi.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.this.id,
      aws_api_gateway_method.this.id,
      aws_api_gateway_resource.this.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_usage_plan" "this" {
  name = "${var.name}-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.api_from_openapi.id
    stage  = aws_api_gateway_stage.this.stage_name
  }

  # TODO: Settings below doesn't generate throttle on usage plan. I have no idea why.
  quota_settings {
    limit  = 1000
    offset = 0
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_api_key" "this" {
  name = var.stage_name
}

resource "aws_api_gateway_usage_plan_key" "this" {
  key_id        = aws_api_gateway_api_key.this.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this.id
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.api_from_openapi.id
  stage_name    = var.stage_name

  cache_cluster_enabled = false
  xray_tracing_enabled  = true
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.api_from_openapi.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    cache_data_encrypted   = true
    cache_ttl_in_seconds   = 300
    caching_enabled        = false
    logging_level          = "INFO"
    metrics_enabled        = true
    throttling_burst_limit = 5
    throttling_rate_limit  = 10
  }
}

// Api gateway account setting for cloudwatch
resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = var.iam_role_arn_api_gateway_cloudwatchawslogs
}

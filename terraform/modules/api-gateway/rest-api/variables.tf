variable "name" {
  description = "Name of api"
  type        = string
  default     = ""
}

variable "openapi_path" {
  description = "OpenAPI specification file path"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of api"
  type        = string
  default     = ""
}

variable "team" {
  description = "Team name"
  type        = string
  default     = "devops"
}

variable "api_key_source" {
  description = "API key source"
  type        = string
  default     = "HEADER"
}

variable "lambda_function_invoke_arn" {
  description = "Lambda invoke arn to be invoked by this api gateway"
  type        = string
  default     = ""
}

variable "lambda_function_name" {
  description = "Lambda name to be invoked by this api gateway"
  type        = string
  default     = ""
}

variable "api_execution_arn" {
  description = "Arn for api execution"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "Aws region for api gateway"
  type        = string
  default     = "ap-northeast-2"
}

variable "lambda_timeout_millis" {
  description = "Lambda timeout in milliseconds"
  type        = number
  default     = 10000
}

variable "stage_name" {
  description = "Stage name for api gateway"
  type        = string
  default     = "dev"
}

variable "acm_certificate_arn" {
  description = "Acm certificate arn for api gateway"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name for api gateway"
  type        = string
  default     = ""
}

# variable "base_path" {
#   description = "Base path for api gateway"
#   type        = string
#   default     = ""
# }

variable "iam_role_arn_api_gateway_cloudwatchawslogs" {
  description = "Iam role arn for api gateway cloudwatch logs"
  type        = string
  default     = ""
}


variable "api_gateway_name" {
  description = "Name of api gateway"
  type        = string
  default     = ""
}

variable "api_key_source" {
  description = "API key source"
  type        = string
  default     = ""
}

variable "lambda_function_name" {
  description = "Lambda name to be invoked by this api gateway"
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
  default     = ""
}

variable "domain_name" {
  description = "Domain name for acm certificate and route53"
  type        = string
  default     = ""
}

variable "host_zone_id" {
  description = "Host zone ID"
  type        = string
  default     = ""
}

# variable "base_path" {
#   description = "Base path for api gateway"
#   type        = string
#   default     = ""
# }

variable "iam_role_api_gateway_cloudwatch_logs_arn" {
  description = "IAM role arn for api gateway cloudwatch logs"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Runtime for lambda"
  type        = string
  default     = ""
}

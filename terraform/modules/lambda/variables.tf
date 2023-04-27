variable "name" {
  description = "Name of lambda function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Function handler for lambda function"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Runtime for lambda function"
  type        = string
  default     = ""
}

variable "layer" {
  description = "Layer of lambda function"
  type        = list(string)
  default     = []
}

variable "lambda_placeholder_path" {
  description = "Path to lambda placeholder"
  type        = string
  default     = ""
}

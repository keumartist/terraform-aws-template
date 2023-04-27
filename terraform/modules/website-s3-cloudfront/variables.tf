variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
  default     = ""
}

variable "domain" {
  description = "Domain name for static website"
  type        = string
  default     = ""
}
variable "env" {
  description = "Environment for static website"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for static website"
  type        = string
  default     = ""
}
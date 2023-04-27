variable "bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "table_name" {
  description = "Name of the DynamoDB table to store Terraform state lock"
  type        = string
  default     = "terraform-state-lock"
}

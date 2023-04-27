provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

locals {
  tfstate_bucket_name = "terraform-state"
  tfstate_table_name  = "terraform-state-lock"
}

module "tfstate_lock_store" {
  source      = "../../modules/tfstate-lock-storage"
  bucket_name = local.tfstate_bucket_name
  table_name  = local.tfstate_table_name
}

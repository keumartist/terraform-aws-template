resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_sse_encryption" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate_access_block" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = var.table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    "team" = "devops"
  }
}

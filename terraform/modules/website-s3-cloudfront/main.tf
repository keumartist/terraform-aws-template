locals {
  s3_origin_id = "s3-${var.domain}"
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags = {
    "team" = "devops"
    "env"  = var.env
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "name" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cloudfront_distribution" "this" {
  depends_on = [aws_s3_bucket.this]

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    # origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id = local.s3_origin_id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  comment             = "Static webstie for ${var.env} environment"
  aliases             = ["${var.domain}"]
  price_class         = "PriceClass_200"
  retain_on_delete    = true

  logging_config {
    include_cookies = false
    bucket          = "${var.domain}.s3.amazonaws.com"
    prefix          = "logs/"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 300
    response_page_path    = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    "team" = "devops"
    "env"  = var.env
  }
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "clodufront-origin-access-control for ${var.domain}"
  description                       = "For ${var.domain}}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_identity" "this" {}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "PolicyForCloudFrontPrivateContent"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

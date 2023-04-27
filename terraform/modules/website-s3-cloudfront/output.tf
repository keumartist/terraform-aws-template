output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.this.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "domain_name" {
  description = "Domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
  description = "Hosted zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

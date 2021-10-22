output "cloudfront_dist_url" {
  value       = "https://${aws_cloudfront_distribution.this.domain_name}"
  description = "CloudFront Distribution URL"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.this.id
  description = "S3 bucket name"
}

output "cloudfront_dist_id" {
  value       = aws_cloudfront_distribution.this.id
  description = "CloudFront Distribution ID"
}
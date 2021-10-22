output "cloudfront_dist_url" {
  value       = module.frontend.cloudfront_dist_url
  description = "CloudFront Distribution URL"
}

output "cloudfront_dist_id" {
  value       = module.frontend.cloudfront_dist_id
  description = "CloudFront Distribution ID"
}

output "s3_bucket_name" {
  value       = module.frontend.s3_bucket_name
  description = "S3 bucket name"
}

output "api-gateway-url" {
  value       = module.backend.api-gateway-url
  description = "API Gateway URL"
}


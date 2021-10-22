variable "region" {
  description = "AWS Region"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "env"{
  description = "Environment"
  type        = string
}

variable "dist_comment" {
  description = "Distribution comment"
  type        = string
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
}

variable "immutable_assets_path_pattern" {
  description = "Immutable assets path pattern"
  type        = string
}

variable "response_403_page_path" {
  description = "403 response page path for single page application"
  type        = string
}

variable "response_404_page_path" {
  description = "404 response page path for single page application"
  type        = string
}

variable "price_class" {
  description = "CloudFront Price Class"
  type        = string
}

variable "cache_max_ttl" {
  description = "Cache max TTL for default behavior"
  type        = number
}

variable "cache_default_ttl" {
  description = "Cache default TTL for default behavior"
  type        = number
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "target_vpc_nlb_arn"{
  description = "ARN of the private VPC for backend load balancers"
  type        = string
}

variable "target_vpc_nlb_endpoint"{
  description = "Endpoint url of the private VPC for backend load balancers"
  type        = string
}

variable "metrics_enabled"{
  description = "Specifies whether Amazon CloudWatch metrics are enabled for this method."
  type        = bool
  default     = true
}

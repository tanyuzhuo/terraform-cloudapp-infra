variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-cloud-single-page-app"
}

variable "env"{
  description = "Environment"
  type        = string
  default     = "test"
}

variable "dist_comment" {
  description = "Distribution comment"
  type        = string
  default     = "Example distribution comment"
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "immutable_assets_path_pattern" {
  description = "Immutable assets path pattern"
  type        = string
  default     = "/static/immutable/*"
}

variable "response_403_page_path" {
  description = "403 response page path for single page application"
  type        = string
  default     = "/assets/accessDenied/accessForbidden.html"
}

variable "response_404_page_path" {
  description = "404 response page path for single page application"
  type        = string
  default     = "/index.html"
}

variable "price_class" {
  description = "CloudFront Price Class"
  type        = string
  default     = "PriceClass_100"
}

variable "cache_max_ttl" {
  description = "Cache max TTL for default behavior"
  type        = number
  default     = 60
}

variable "cache_default_ttl" {
  description = "Cache default TTL for default behavior"
  type        = number
  default     = 30
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "api-gateway-url"{
  description = "Domain url of the backend api gateway"
  type        = string
}

variable "api-gateway-api-key"{
  description = "API key for the backend api Gateway"
  type        = string
}


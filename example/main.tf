provider "aws" {
  profile = "default"
  region  = var.region
}

module "frontend" {
  source                        = "../modules/cf_s3"
  app_name                      = var.app_name
  env                           = var.env
  dist_comment                  = var.dist_comment
  region                        = var.region
  default_root_object           = var.default_root_object
  immutable_assets_path_pattern = var.immutable_assets_path_pattern
  response_403_page_path        = var.response_403_page_path
  response_404_page_path        = var.response_404_page_path
  price_class                   = var.price_class
  cache_max_ttl                 = var.cache_max_ttl
  cache_default_ttl             = var.cache_default_ttl
  s3_bucket_name                = var.s3_bucket_name
  api-gateway-url               = module.backend.api-gateway-url
  api-gateway-api-key           = module.backend.api-gateway-api-key 
}

module "backend" {
  source                        = "../modules/apigw_vpclink"
  app_name                      = var.app_name
  region                        = var.region
  env                           = var.env 
  target_vpc_nlb_arn            = var.target_vpc_nlb_arn
  target_vpc_nlb_endpoint       = var.target_vpc_nlb_endpoint   
}
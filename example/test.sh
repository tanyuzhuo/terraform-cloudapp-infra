#!/bin/sh
 
export TF_VAR_env="test"
export TF_VAR_region="eu-west-2"
export TF_VAR_app_name="my-test-single-page-app"
export TF_VAR_dist_comment="my-test-distribution-comment"
export TF_VAR_default_root_object="index.html"
export TF_VAR_immutable_assets_path_pattern="/static/immutable/*"
export TF_VAR_response_403_page_path="/assets/accessDenied/accessForbidden.html"
export TF_VAR_response_404_page_path="/index.html"
export TF_VAR_price_class="PriceClass_100"
export TF_VAR_cache_max_ttl=60
export TF_VAR_cache_default_ttl=30
export TF_VAR_s3_bucket_name="my-single-page-app-s3-bucket"
export TF_VAR_target_vpc_nlb_arn="arn:aws:elasticloadbalancing:{region}:{account}:loadbalancer/net/{name}"
export TF_VAR_target_vpc_nlb_endpoint="{nlb endpoint url}"

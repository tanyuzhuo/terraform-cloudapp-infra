locals {
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
  acl_id                        = "${var.app_name}-${var.env}-acl"
  s3_origin_id                  = "${var.app_name}-s3-origin-id"
  backend_origin_id             = "${var.app_name}-apigw-origin-id"
  api-gateway-url               = var.api-gateway-url
  api-gateway-api-key           = var.api-gateway-api-key
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${var.dist_comment} - OAI"
}

resource "aws_s3_bucket" "this" {
  bucket = local.s3_bucket_name
  acl    = "private"

  tags = {
    App = local.app_name
  }
}

data "aws_iam_policy_document" "s3_oai_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [aws_s3_bucket.this.arn, "${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_oai_policy.json
}

resource "aws_cloudfront_distribution" "this" {
  depends_on = [
    aws_waf_web_acl.this
  ]

  viewer_certificate{
    cloudfront_default_certificate = true
  }

  web_acl_id = aws_waf_web_acl.this.id

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = local.api-gateway-url
    
    origin_id   = local.backend_origin_id
    origin_path = "/${local.env}"
    custom_header {
      name  = "x-api-key"
      value = local.api-gateway-api-key 
    }
    custom_origin_config  {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1"]
    }
    
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = local.dist_comment
  default_root_object = local.default_root_object

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = local.cache_default_ttl
    max_ttl                = local.cache_max_ttl
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.backend_origin_id

    forwarded_values {
      query_string = true
      headers = ["Authorization"]

      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = false
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = local.immutable_assets_path_pattern
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  custom_error_response {
    error_code = 403
    response_code= 403
    response_page_path= local.response_403_page_path
    error_caching_min_ttl = 0
  }

  custom_error_response {   
    error_code = 404
    response_code= 200
    response_page_path= local.response_404_page_path
    error_caching_min_ttl = 0
  }
  
  price_class = local.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    App = local.app_name
  }

}

resource "aws_waf_rule" "this" {
  depends_on = [
    aws_waf_ipset.this
  ]
  name        = "${local.acl_id}-ip-filter"
  metric_name = "ipfilterrule"

  predicates {
    data_id = aws_waf_ipset.this.id
    negated = false
    type    = "IPMatch"
  }
}

data "template_file" "ip-ranges-whitelist" {
  template = file("ip-ranges-whitelist.json")
  vars = {
  }
}

resource "aws_waf_ipset" "this" {
  name = "${local.acl_id}-ipset"

  dynamic "ip_set_descriptors" {
    for_each = toset(jsondecode(data.template_file.ip-ranges-whitelist.rendered))
    content {
      type  = "IPV4"
      value = ip_set_descriptors.key
    }
  }
}

resource "aws_waf_web_acl" "this" {
  depends_on = [
    aws_waf_rule.this,
    aws_waf_ipset.this
  ]
  name        = local.acl_id
  metric_name = "ipfilteracl"

  default_action {
    type = "BLOCK"
  }

  rules {
    priority = 10
    rule_id  = aws_waf_rule.this.id

    action {
      type = "ALLOW"
    }
  }
}
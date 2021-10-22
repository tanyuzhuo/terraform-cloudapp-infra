locals {
  app_name                      = var.app_name
  region                        = var.region
  env                           = var.env
  api_gateway_name              = "${var.app_name}-${var.env}-api-gateway"
  api_gateway_vpc_link_name     = "${var.app_name}-${var.env}-api-gateway-vpc-link"
  api_gateway_usage_plan        = "${var.app_name}-${var.env}-api-gateway-usage-plan"
  api_gateway_usage_plan_key    = "${var.app_name}-${var.env}-api-gateway-usage-plan_key"
  target_vpc_nlb_arn            = var.target_vpc_nlb_arn
  target_vpc_nlb_endpoint       = var.target_vpc_nlb_endpoint
  metrics_enabled               = var.metrics_enabled
}

resource "aws_api_gateway_rest_api" "this" {
  name = local.api_gateway_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_vpc_link" "this" {
  name        = local.api_gateway_vpc_link_name
  description = "VPC link connect to the backend load balancers"
  target_arns = [local.target_vpc_nlb_arn]
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "ANY"
  authorization = "NONE"
  api_key_required = true
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this.http_method

  request_parameters = {
      "integration.request.path.proxy" = "method.request.path.proxy"
  }

  type                    = "HTTP_PROXY"
  uri                     = "${local.target_vpc_nlb_endpoint}/{proxy}"
  integration_http_method = "ANY"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.this.id
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [aws_api_gateway_integration.this]

  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = local.env

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_usage_plan" "this" {
  name = local.api_gateway_usage_plan

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_deployment.this.stage_name
  }
}

resource "aws_api_gateway_api_key" "this" {
  name = local.api_gateway_usage_plan_key
}

resource "aws_api_gateway_usage_plan_key" "this" {
  key_id        = aws_api_gateway_api_key.this.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this.id
}

resource "aws_api_gateway_rest_api_policy" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*",
            "Condition": {
                "StringEquals": {
                    "aws:UserAgent": "Amazon CloudFront"
                  }
              }
          }
      ]
  }
  EOF
}

resource "aws_api_gateway_method_settings" "this" {
  depends_on  = [aws_api_gateway_deployment.this]
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_deployment.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = local.metrics_enabled
  }
}
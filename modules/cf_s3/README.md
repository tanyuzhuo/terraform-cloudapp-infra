## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.55 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.55 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_waf_ipset.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_ipset) | resource |
| [aws_waf_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rule) | resource |
| [aws_waf_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_web_acl) | resource |
| [aws_iam_policy_document.s3_oai_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.ip-ranges-whitelist](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api-gateway-api-key"></a> [api-gateway-api-key](#input\_api-gateway-api-key) | API key for the backend api Gateway | `string` | n/a | yes |
| <a name="input_api-gateway-url"></a> [api-gateway-url](#input\_api-gateway-url) | Domain url of the backend api gateway | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | `"my-cloud-single-page-app"` | no |
| <a name="input_cache_default_ttl"></a> [cache\_default\_ttl](#input\_cache\_default\_ttl) | Cache default TTL for default behavior | `number` | `30` | no |
| <a name="input_cache_max_ttl"></a> [cache\_max\_ttl](#input\_cache\_max\_ttl) | Cache max TTL for default behavior | `number` | `60` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Default root object | `string` | `"index.html"` | no |
| <a name="input_dist_comment"></a> [dist\_comment](#input\_dist\_comment) | Distribution comment | `string` | `"Example distribution comment"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | `"test"` | no |
| <a name="input_immutable_assets_path_pattern"></a> [immutable\_assets\_path\_pattern](#input\_immutable\_assets\_path\_pattern) | Immutable assets path pattern | `string` | `"/static/immutable/*"` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | CloudFront Price Class | `string` | `"PriceClass_100"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"eu-west-2"` | no |
| <a name="input_response_403_page_path"></a> [response\_403\_page\_path](#input\_response\_403\_page\_path) | 403 response page path for single page application | `string` | `"/assets/accessDenied/accessForbidden.html"` | no |
| <a name="input_response_404_page_path"></a> [response\_404\_page\_path](#input\_response\_404\_page\_path) | 404 response page path for single page application | `string` | `"/index.html"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_dist_id"></a> [cloudfront\_dist\_id](#output\_cloudfront\_dist\_id) | CloudFront Distribution ID |
| <a name="output_cloudfront_dist_url"></a> [cloudfront\_dist\_url](#output\_cloudfront\_dist\_url) | CloudFront Distribution URL |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | S3 bucket name |
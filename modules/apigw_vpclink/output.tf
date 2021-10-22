output "api-gateway-url" {
  value       = split("/", aws_api_gateway_deployment.this.invoke_url)[2]
  description = "API Gateway URL"
}

output "api-gateway-api-key" {
  value       =  aws_api_gateway_api_key.this.value
  description = "API Key for the API Gateway"
}



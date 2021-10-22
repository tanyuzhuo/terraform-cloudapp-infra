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

variable "target_vpc_nlb_arn"{
  description = "ARN of the private VPC for legacy/backend load balancer"
  type        = string
}

variable "target_vpc_nlb_endpoint"{
  description = "Endpoint url of the private VPC for legacy/backend load balancer"
  type        = string
}

variable "metrics_enabled"{
  description = "Specifies whether Amazon CloudWatch metrics are enabled for this method."
  type        = bool
  default     = true
}


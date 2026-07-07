variable "environment" {
  type        = string
  description = "Project environment dev/prod"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be exactly 'dev' or 'prod'."
  }
}

variable "project_name" {
  type        = string
  description = "Project name used for naming AWS resources and applying standard tags."
}

variable "common_tags" {
  description = "Common resource tags shared across the project."
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID passed from network module."
  type        = string
}

variable "certificate_arn" {
  description = "The TLS Certificate ARN for ALB HTTPS listener"
}

variable "public_subnet_ids" {
  description = "List of IDs of public subnets."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ALB security Group ID"
  type        = string
}
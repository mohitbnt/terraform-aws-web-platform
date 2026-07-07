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

variable "cloudflare_zone_id" {
  description = "Cloudfalre Zone ID of your domain name"
  type        = string
}

variable "domain_name" {
  description = "The root domain"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB."
  type        = string
}
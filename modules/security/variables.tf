variable "environment" {
  type        = string
  description = "Project environment dev/prod"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be exactly 'dev' or 'prod'."
  }
}

variable "project_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  description = "VPC ID passed from network module."
  type        = string
}

variable "enable_nat_instance" {
  type    = bool
  default = true
}
# AWS Region
###############################################################
variable "aws_region" {
  type        = string
  description = "The target AWS region for deployment"

  validation {
    # Regex checks for standard regional patterns like "us-east-1" or "ap-southeast-2"
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "The aws_region value must be a valid AWS region identifier (e.g., us-east-1, eu-west-2)."
  }
}

# Project Environment
###############################################################
variable "environment" {
  type        = string
  description = "Project environment dev/prod"
  default     = "prod"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be exactly 'dev' or 'prod'."
  }
}
# Project Name
###############################################################
variable "project_name" {
  description = "Name of the project"
  type        = string
}

# Cloudflare
###############################################################
variable "cloudflare_api_token" {
  description = "Cloudflare API Toen"
  type        = string
  sensitive   = true
}
variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID of the domain"
  type        = string
}

# ACM
###############################################################
variable "domain_name" {
  description = "Primary domain name"
  type        = string
  validation {
    condition     = length(var.domain_name) > 3
    error_message = "A valid domain must be provided."
  }
}

# VPC and Subnets
###############################################################
variable "vpc_cidr" {
  type = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The vpc cidr must be valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Explicit list of CIDR blocks for the public subnets"
  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All elements in the public_subnet_cidrs list must be valid IPv4 CIDR blocks."
  }

}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Explicit list of CIDR blocks for the private subnets"
  validation {
    # Loops through the list to ensure every single entry is a valid CIDR
    condition     = alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All elements in the public_subnet_cidrs list must be valid IPv4 CIDR blocks."
  }
}

# NAT and Application Configuration
###############################################################
variable "enable_nat_instance" {
  type        = bool
  description = "Controls whether resources required for the NAT instance are created."
  default     = true
}

variable "nat_instance_config" {
  description = "Configuration for the NAT instance."

  type = object({
    instance_type         = string
    root_volume_size      = number
    root_volume_type      = string
    root_volume_encrypted = bool
  })
}

variable "application_config" {
  description = "Configuration for the application compute fleet."

  type = object({
    instance_type = string

    root_volume_size      = number
    root_volume_type      = string
    root_volume_encrypted = bool

    desired_capacity = number
    min_size         = number
    max_size         = number

    health_check_grace_period = number
    health_check_type         = string

    protect_scale_in   = bool
    termination_policy = list(string)
  })
}
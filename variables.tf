# AWS Region
###############################################################
variable "aws_region" {
  type    = string
  default = "us-east-1"
  validation {
    condition     = contains(["us-east-1", "us-east-2"], var.aws_region)
    error_message = "Authorized regions are limited to us-east-1 or us-east-2."
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

variable "project_name" {
  type = string
}

# SSH Key Pair
###############################################################
variable "key_name" {
  type        = string
  description = "Existing EC2 Key Pair name"
  default     = null
}

# ASG Variables
###############################################################
variable "asg_configuration" {
  type = map(object({
    desired            = number
    min                = number
    max                = number
    grace_period       = number
    protect_scale_in   = bool
    termination_policy = string
  }))

  default = {
    dev = {
      desired            = 1
      min                = 1
      max                = 2
      grace_period       = 300
      protect_scale_in   = false
      termination_policy = "OldestLaunchTemplate"
    }

    prod = {
      desired            = 2
      min                = 2
      max                = 4
      grace_period       = 300
      protect_scale_in   = false
      termination_policy = "OldestLaunchTemplate"
    }
  }
}

# Cloudflare
###############################################################
variable "cloudflare_api_token" {
  description = "Cloudflare API Toen"
  type        = string
  sensitive   = true
}
variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
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

#------------------------------------------------------------------------------------
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
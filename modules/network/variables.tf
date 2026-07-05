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
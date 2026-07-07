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

variable "enable_nat_instance" {
  type        = bool
  description = "Controls whether resources required for the NAT instance are created."
  default     = true
}

variable "nat_instance_profile_name" {
  description = "Instance profile name for NAT instance."
  type        = string
}

variable "ec2_instance_profile_name" {
  description = "Instance profile name for auto scaling group's instances."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of IDs of public subnets."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of IDs of private subnets."
  type        = list(string)
}

variable "nat_security_group_id" {
  description = "List of seccurity group IDs for NAT intance."
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "List of security group IDs for auto scalling group instances."
  type        = list(string)
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

variable "target_group_arns" {
  description = "list of ARNs of target groups"
  type        = list(string)
}
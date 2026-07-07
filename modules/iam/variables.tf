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
######################################
# Load Balancer Networking Variables
######################################

variable "vpc_name" {
  description = "The base name for resources inside the compute module."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_name)) > 0
    error_message = "The vpc_name must not be empty. Provide a meaningful name."
  }
}

variable "vpc_id" {
  description = "The ID of the created VPC."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]{8,17}$", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID (e.g., vpc-xxxxxxxx)."
  }
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the Load Balancer."
  type        = list(string)

  validation {
    condition = alltrue([
      for subnet_id in var.public_subnet_ids : can(regex("^subnet-[a-f0-9]{8,17}$", subnet_id))
    ])
    error_message = "Each subnet ID must be a valid AWS Subnet ID (e.g., subnet-xxxxxxxx)."
  }
}

variable "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer."
  type        = string

  validation {
    condition     = can(regex("^sg-[a-f0-9]{8,17}$", var.alb_sg_id))
    error_message = "The alb_sg_id must be a valid AWS Security Group ID (e.g., sg-xxxxxxxx)."
  }
}

######################################
# Common Tagging
######################################

variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)

  validation {
    condition     = length(keys(var.common_tags)) > 0
    error_message = "The common_tags map must contain at least one tag."
  }
}

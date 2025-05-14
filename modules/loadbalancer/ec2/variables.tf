##############################
# Networking & Load Balancer Configuration
##############################

variable "vpc_name" {
  description = "The base name for resources inside the compute module."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the created VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to attach to the load balancer."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer."
  type        = string
}

##############################
# Common Settings
##############################

variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

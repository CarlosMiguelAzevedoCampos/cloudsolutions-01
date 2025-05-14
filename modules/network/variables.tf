######################################
# General AWS Configuration
######################################

variable "aws_region" {
  description = "The AWS region where resources will be deployed (e.g., eu-central-1, us-east-1)."
  type        = string
}

variable "vpc_name" {
  description = "The name to assign to the VPC and related networking resources."
  type        = string
}

######################################
# Networking Configuration
######################################

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets within the VPC."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets inside the VPC (e.g., ['10.0.11.0/24', '10.0.12.0/24'])."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AWS availability zones to launch public subnets into (e.g., ['us-east-1a', 'us-east-1b'])."
  type        = list(string)
}

variable "public_route_cidr" {
  description = "The CIDR block used for default routing (usually 0.0.0.0/0 to allow all outbound internet traffic)."
  type        = string
}

######################################
# Common Tags
######################################

variable "common_tags" {
  description = "Common tags applied to all AWS resources."
  type        = map(string)
}

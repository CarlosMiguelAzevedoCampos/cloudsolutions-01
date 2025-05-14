######################################
# Networking Configuration
######################################

variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created."
  type        = string
}

variable "vpc_name" {
  description = "The base name for tagging all security groups."
  type        = string
}

######################################
# Common Tags
######################################

variable "common_tags" {
  description = "Common tags applied to all AWS resources."
  type        = map(string)
}

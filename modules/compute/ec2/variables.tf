##############################
# EC2 Instance Configuration
##############################

variable "vpc_name" {
  description = "The base name for resources inside the compute module."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to launch for EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t3.micro, t3.medium)."
  type        = string
}

variable "user_data" {
  description = "User data script to bootstrap EC2 instances."
  type        = string
  default     = ""
}

variable "app_sg_id" {
  description = "Security Group ID to associate with EC2 instances."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Auto Scaling Group."
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN where instances will be registered (for ALB)."
  type        = string
}

##############################
# Auto Scaling Group Settings
##############################

variable "desired_capacity" {
  description = "The desired number of EC2 instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 4
}

variable "scale_up_cooldown" {
  description = "Cooldown period (in seconds) after a scale-up activity before another can start."
  type        = number
}

variable "scale_down_cooldown" {
  description = "Cooldown period (in seconds) after a scale-down activity before another can start."
  type        = number
}

##############################
# S3 Buckets
##############################

variable "s3_data_saving_bucket_name" {
  description = "S3 bucket name used to save data."
  type        = string
  default     = ""
}

variable "s3_code_bucket_name" {
  description = "S3 bucket name that has the python code."
  type        = string
  default     = ""
}

##############################
# Common Settings
##############################

variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

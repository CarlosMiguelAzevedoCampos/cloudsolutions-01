##############################
# General Configuration
##############################

variable "vpc_name" {
  description = "The base name for resources inside the compute module."
  type        = string
}

variable "region" {
  description = "AWS region for the resources."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

##############################
# ECS Cluster and Networking
##############################

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS Service."
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security Group ID for the ECS tasks."
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN for the Load Balancer."
  type        = string
}

##############################
# ECS Task Definition
##############################

variable "container_image" {
  description = "Container image to deploy in the ECS task."
  type        = string
}

variable "container_port" {
  description = "Port that the container listens on."
  type        = number
}

variable "task_cpu" {
  description = "The number of CPU units used by the ECS task."
  type        = number
}

variable "task_memory" {
  description = "The amount of memory (in MiB) used by the ECS task."
  type        = number
}

##############################
# S3 Buckets
##############################

variable "s3_data_bucket_name" {
  description = "S3 bucket name used by ECS tasks to save data."
  type        = string
}

##############################
# ECS Service AutoScaling
##############################

variable "desired_count" {
  description = "Desired number of ECS tasks to run."
  type        = number
}

variable "minimum_count" {
  description = "Minimum number of ECS tasks for autoscaling."
  type        = number
}

variable "maximum_count" {
  description = "Maximum number of ECS tasks for autoscaling."
  type        = number
}

variable "scale_up_cooldown" {
  description = "Cooldown period (in seconds) after a scale-up activity."
  type        = number
}

variable "scale_down_cooldown" {
  description = "Cooldown period (in seconds) after a scale-down activity."
  type        = number
}

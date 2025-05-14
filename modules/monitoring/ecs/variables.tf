######################################
# General Configuration
######################################

variable "vpc_name" {
  description = "The base name for resources inside the compute module."
  type        = string
}

######################################
# ECS Monitoring Configuration
######################################

variable "cluster_name" {
  description = "The name of the ECS cluster where the service is running."
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service to monitor for CPU usage."
  type        = string
}

variable "scale_up_policy_arn" {
  description = "ARN of the ECS Application Auto Scaling policy used to scale up the ECS service."
  type        = string
}

variable "scale_down_policy_arn" {
  description = "ARN of the ECS Application Auto Scaling policy used to scale down the ECS service."
  type        = string
}

######################################
# Resource Tags
######################################

variable "common_tags" {
  description = "Common resource tags applied to all monitoring resources."
  type        = map(string)
}

######################################
# CPU Alarm Thresholds
######################################

variable "cpu_high_threshold" {
  description = "CPU utilization percentage that will trigger the high alarm and scale up."
  type        = number
}

variable "cpu_low_threshold" {
  description = "CPU utilization percentage that will trigger the low alarm and scale down."
  type        = number
}

variable "cpu_high_period" {
  description = "The period (in seconds) to evaluate CPU utilization for the high alarm."
  type        = number
}

variable "cpu_low_period" {
  description = "The period (in seconds) to evaluate CPU utilization for the low alarm."
  type        = number
}


variable "cpu_high_evaluation_periods" {
  description = "Number of consecutive periods above threshold to trigger scale-out"
  type        = number
  default     = 2
}

variable "cpu_low_evaluation_periods" {
  description = "Number of consecutive periods below threshold to trigger scale-in"
  type        = number
  default     = 2
}
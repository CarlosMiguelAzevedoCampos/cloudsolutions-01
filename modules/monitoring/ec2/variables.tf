######################################
# General Configuration
######################################

variable "region" {
  type        = string
  description = "AWS region where resources will be deployed."
}

variable "vpc_name" {
  type        = string
  description = "The base name for resources inside the compute module."
}

######################################
# Auto Scaling Group Monitoring
######################################

variable "autoscaling_group_name" {
  type        = string
  description = "Name of the Auto Scaling Group to monitor."
}

variable "scale_up_policy_arn" {
  type        = string
  description = "ARN of the Auto Scaling Scale-Up policy."
}

variable "scale_down_policy_arn" {
  type        = string
  description = "ARN of the Auto Scaling Scale-Down policy."
}

######################################
# Resource Tags
######################################

variable "common_tags" {
  type        = map(string)
  description = "Common resource tags applied to all monitoring resources."
}

######################################
# CPU Alarm Thresholds
######################################

variable "cpu_high_threshold" {
  type        = number
  description = "CPU utilization percentage that will trigger the high alarm and scale up."
}

variable "cpu_low_threshold" {
  type        = number
  description = "CPU utilization percentage that will trigger the low alarm and scale down."
}

variable "cpu_high_period" {
  type        = number
  description = "The period (in seconds) to evaluate CPU utilization for the high alarm."
}

variable "cpu_low_period" {
  type        = number
  description = "The period (in seconds) to evaluate CPU utilization for the low alarm."
}


variable "cpu_high_evaluation_periods" {
  description = "Number of consecutive periods above threshold to trigger scale-out"
  type        = number
}

variable "cpu_low_evaluation_periods" {
  description = "Number of consecutive periods below threshold to trigger scale-in"
  type        = number
}
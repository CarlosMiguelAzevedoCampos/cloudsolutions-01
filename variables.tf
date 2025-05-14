##############################
# Base Configuration (Shared / Common)
##############################

variable "aws_region" {
  description = "The AWS region where resources will be deployed (e.g., eu-central-1, us-east-1)."
  type        = string
  default     = "eu-central-1"

  validation {
    condition = contains([
      "af-south-1", "ap-east-1", "ap-south-1", "ap-northeast-1",
      "ap-northeast-2", "ap-northeast-3", "ap-southeast-1", "ap-southeast-2",
      "ca-central-1", "eu-central-1", "eu-west-1", "eu-west-2",
      "eu-west-3", "eu-north-1", "eu-south-1", "me-south-1",
      "sa-east-1", "us-east-1", "us-east-2", "us-west-1",
      "us-west-2"
    ], var.aws_region)
    error_message = "The region must be a valid AWS region code."
  }
}

variable "vpc_name" {
  description = "The name to assign to the VPC and related networking resources."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_name)) > 0
    error_message = "The vpc_name must not be empty."
  }
}

variable "common_tags" {
  description = "Common tags applied to all AWS resources."
  type        = map(string)
  default = {
    Environment = "QA"
    Owner       = "Cloud Solutions Inc."
    ManagedBy   = "Terraform"
    Project     = "CloudSolutions-WebApp"
    CostCenter  = "Cloud-Infrastructure"
  }
}

##############################
# Networking Configuration
##############################

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC network range."
  type        = string

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.vpc_cidr_block))
    error_message = "Must be a valid CIDR string (e.g., 10.0.0.0/16)."
  }
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", cidr))
    ])
    error_message = "Each public subnet must be a valid CIDR block."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", cidr))
    ])
    error_message = "Each private subnet must be a valid CIDR block."
  }
}

variable "availability_zones" {
  description = "List of AWS availability zones for subnet deployment."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

variable "public_route_cidr" {
  description = "The CIDR block used for default routing."
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.public_route_cidr))
    error_message = "Must be a valid CIDR block."
  }
}

##############################
# Storage Buckets
##############################

variable "s3_data_save_bucket_name" {
  description = "Prefix for the S3 bucket to store application data."
  type        = string

  validation {
    condition     = length(trimspace(var.s3_data_save_bucket_name)) > 0
    error_message = "Bucket name must not be empty."
  }
}


##############################
# EC2 Compute Configuration
##############################

variable "s3_code_bucket_name" {
  description = "Prefix for the S3 bucket to store application code."
  type        = string

  validation {
    condition     = length(trimspace(var.s3_code_bucket_name)) > 0
    error_message = "Bucket name must not be empty."
  }
}


variable "ec2_ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to launch."
  type        = string

  validation {
    condition     = can(regex("^ami-[a-f0-9]{8,17}$", var.ec2_ami_id))
    error_message = "Must be a valid AMI ID."
  }
}

variable "ec2_instance_type" {
  description = "The EC2 instance type."
  type        = string

  validation {
    condition     = length(trimspace(var.ec2_instance_type)) > 0
    error_message = "Instance type must not be empty."
  }
}

variable "ec2_user_data" {
  description = "User-data script for EC2 instances."
  type        = string
  default     = ""
}

variable "ec2_desired_capacity" {
  description = "Desired number of instances in the EC2 Auto Scaling Group."
  type        = number
  default     = 2

  validation {
    condition     = var.ec2_desired_capacity >= 1
    error_message = "Must be at least 1."
  }
}

variable "ec2_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 2

  validation {
    condition     = var.ec2_min_size >= 1
    error_message = "Must be at least 1."
  }
}

variable "ec2_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 4

  validation {
    condition     = var.ec2_max_size >= var.ec2_min_size
    error_message = "Must be greater than or equal to min_size."
  }
}

##############################
# ECS Compute Configuration
##############################
/*
variable "ecr_container_image" {
  description = "ECR container image URI."
  type        = string

  validation {
    condition     = length(trimspace(var.ecr_container_image)) > 0
    error_message = "Image URI must not be empty."
  }
}

variable "ecs_container_port" {
  description = "Container port exposed by the ECS task."
  type        = number

  validation {
    condition     = var.ecs_container_port > 0 && var.ecs_container_port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}

variable "ecs_task_cpu" {
  description = "Number of CPU units used by the ECS task."
  type        = number

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.ecs_task_cpu)
    error_message = "Must be one of 256, 512, 1024, 2048, 4096."
  }
}

variable "ecs_task_memory" {
  description = "Amount of memory (MiB) for the ECS task."
  type        = number

  validation {
    condition     = var.ecs_task_memory >= 512 && var.ecs_task_memory <= 30720
    error_message = "Must be between 512 and 30720 MiB."
  }
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks."
  type        = number

  validation {
    condition     = var.ecs_desired_count >= 1
    error_message = "Must be at least 1."
  }
}

variable "ecs_maximum_count" {
  description = "Maximum number of ECS tasks."
  type        = number

  validation {
    condition     = var.ecs_maximum_count >= 1
    error_message = "Must be at least 1."
  }
}

variable "ecs_minimum_count" {
  description = "Minimum number of ECS tasks."
  type        = number

  validation {
    condition     = var.ecs_minimum_count >= 1
    error_message = "Must be at least 1."
  }
}
*/
##############################
# AutoScaling Cooldowns (Shared by EC2 and ECS)
##############################

variable "scale_up_cooldown" {
  description = "Cooldown (seconds) after a scale-up event."
  type        = number

  validation {
    condition     = var.scale_up_cooldown > 0
    error_message = "Must be greater than 0."
  }
}

variable "scale_down_cooldown" {
  description = "Cooldown (seconds) after a scale-down event."
  type        = number

  validation {
    condition     = var.scale_down_cooldown > 0
    error_message = "Must be greater than 0."
  }
}

##############################
# Monitoring Alarms (CPU thresholds)
##############################

variable "cpu_high_threshold" {
  description = "CPU utilization % to trigger scale-up."
  type        = number

  validation {
    condition     = var.cpu_high_threshold >= 1 && var.cpu_high_threshold <= 100
    error_message = "Must be between 1 and 100."
  }
}

variable "cpu_low_threshold" {
  description = "CPU utilization % to trigger scale-down."
  type        = number

  validation {
    condition     = var.cpu_low_threshold >= 0 && var.cpu_low_threshold < 100
    error_message = "Must be between 0 and 99."
  }
}

variable "cpu_high_period" {
  description = "Period (seconds) to evaluate high CPU."
  type        = number

  validation {
    condition     = var.cpu_high_period > 0
    error_message = "Must be a positive number."
  }
}

variable "cpu_low_period" {
  description = "Period (seconds) to evaluate low CPU."
  type        = number

  validation {
    condition     = var.cpu_low_period > 0
    error_message = "Must be a positive number."
  }
}

variable "cpu_high_evaluation_periods" {
  description = "Number of consecutive periods above threshold to trigger scale-out"
  type        = number
  validation {
    condition     = var.cpu_high_evaluation_periods > 0
    error_message = "cpu_high_evaluation_periods Must be a positive number."
  }
}

variable "cpu_low_evaluation_periods" {
  description = "Number of consecutive periods below threshold to trigger scale-in"
  type        = number
  validation {
    condition     = var.cpu_low_evaluation_periods > 0
    error_message = "Must be a positive number."
  }
}
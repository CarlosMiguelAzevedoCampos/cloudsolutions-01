aws_region = "eu-central-1"

vpc_name = "cloudsolutions"

vpc_cidr_block = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.6.0/24",
  "10.0.7.0/24"
]

availability_zones = [
  "eu-central-1a",
  "eu-central-1b"
]

public_route_cidr = "0.0.0.0/0"

# ---------------- EC2 related variables ----------------
ec2_ami_id           = "ami-009082a6cd90ccd0e"       # For EC2 instances
ec2_instance_type    = "t3.micro"                   # For EC2 instances
ec2_user_data        = ""                            # For EC2 instances (startup scripts)
ec2_desired_capacity = 1                            # Auto Scaling Group desired capacity for EC2
ec2_min_size         = 1                             # Auto Scaling Group min size for EC2
ec2_max_size         = 4                             # Auto Scaling Group max size for EC2
s3_code_bucket_name = "cloudsolutions-code-app-01"    # Only used by EC2 for deploying code

# ---------------- Shared for EC2 and ECS (storage) ----------------
s3_data_save_bucket_name = "cloudsolutions-app-01"    # Used by EC2 and ECS to save data


# ---------------- ECS related variables ----------------
#ecr_container_image = "163381208010.dkr.ecr.eu-central-1.amazonaws.com/container-app-01:v1.0.0"  # ECS container image
#ecs_container_port = 80         # ECS container port
#ecs_task_cpu       = 512         # CPU units for ECS task
#ecs_task_memory    = 1024        # Memory for ECS task
#ecs_desired_count  = 1           # Desired number of ECS tasks
#ecs_minimum_count  = 1           # Minimum number of ECS tasks
#ecs_maximum_count  = 4           # Maximum number of ECS tasks

# ---------------- Shared for EC2 and ECS (autoscaling policies) ----------------
scale_up_cooldown   = 60          # Cooldown for scaling up (EC2 and ECS)
scale_down_cooldown = 300         # Cooldown for scaling down (EC2 and ECS)

cpu_high_threshold = 10          # CPU % threshold to scale up (EC2 and ECS)
cpu_low_threshold  = 5          # CPU % threshold to scale down (EC2 and ECS)
cpu_high_period    = 60         # CPU high evaluation period (EC2 and ECS)
cpu_low_period     = 300         # CPU low evaluation period (EC2 and ECS)
cpu_high_evaluation_periods = 2
cpu_low_evaluation_periods = 2

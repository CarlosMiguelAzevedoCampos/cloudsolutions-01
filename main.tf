module "network" {
  source = "./modules/network"

  vpc_name             = var.vpc_name
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
  public_route_cidr    = var.public_route_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags          = var.common_tags
  aws_region           = var.aws_region
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.network.vpc_id
  vpc_name    = var.vpc_name
  common_tags = var.common_tags
}


module "storage" {
  source         = "./modules/storage"
  common_tags    = var.common_tags
  s3_bucket_name = var.s3_data_save_bucket_name
}

module "loadbalancer_ec2" {
  source            = "./modules/loadbalancer/ec2"
  vpc_id            = module.network.vpc_id
  vpc_name          = var.vpc_name
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  common_tags       = var.common_tags
}

module "ec2" {
  source                     = "./modules/compute/ec2"
  vpc_name                   = var.vpc_name
  common_tags                = var.common_tags
  ami_id                     = var.ec2_ami_id
  instance_type              = var.ec2_instance_type
  user_data                  = var.ec2_user_data
  private_subnet_ids         = module.network.private_subnet_ids
  app_sg_id                  = module.security.app_sg_id
  target_group_arn           = module.loadbalancer_ec2.ec2_target_group_arn
  desired_capacity           = var.ec2_desired_capacity
  min_size                   = var.ec2_min_size
  max_size                   = var.ec2_max_size
  s3_code_bucket_name        = var.s3_code_bucket_name
  s3_data_saving_bucket_name = var.s3_data_save_bucket_name
  scale_down_cooldown        = var.scale_down_cooldown
  scale_up_cooldown          = var.scale_up_cooldown
}

module "monitoring_ec2" {
  source = "./modules/monitoring/ec2"

  vpc_name                    = var.vpc_name
  region                      = var.aws_region
  autoscaling_group_name      = module.ec2.autoscaling_group_name
  scale_up_policy_arn         = module.ec2.scale_up_policy_arn
  scale_down_policy_arn       = module.ec2.scale_down_policy_arn
  common_tags                 = var.common_tags
  cpu_high_period             = var.cpu_high_period
  cpu_high_threshold          = var.cpu_high_threshold
  cpu_low_period              = var.cpu_low_period
  cpu_low_threshold           = var.cpu_low_threshold
  cpu_high_evaluation_periods = var.cpu_high_evaluation_periods
  cpu_low_evaluation_periods  = var.cpu_low_evaluation_periods
}


/*

module "loadbalancer_ecs" {
  source            = "./modules/loadbalancer/ecs"
  vpc_id            = module.network.vpc_id
  vpc_name          = var.vpc_name
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  common_tags       = var.common_tags
}


module "ecs" {
  source = "./modules/compute/ecs"
  
  container_image     = var.ecr_container_image
  container_port      = var.ecs_container_port
  task_cpu            = var.ecs_task_cpu
  task_memory         = var.ecs_task_memory
  desired_count       = var.ecs_desired_count
  ecs_sg_id           = module.security.app_sg_id
  private_subnet_ids  = module.network.private_subnet_ids
  s3_data_bucket_name = module.storage.s3_bucket_name
  target_group_arn    = module.loadbalancer_ecs.ecs_target_group_arn
  region              = var.aws_region
  common_tags         = var.common_tags
  maximum_count       = var.ecs_maximum_count
  minimum_count       = var.ecs_minimum_count
  vpc_name            = var.vpc_name
  scale_down_cooldown = var.scale_down_cooldown
  scale_up_cooldown   = var.scale_up_cooldown
}

module "monitoring_ecs" {
  source                      = "./modules/monitoring/ecs"
  service_name                = module.ecs.ecs_service_name
  cluster_name                = module.ecs.ecs_cluster_name
  scale_up_policy_arn         = module.ecs.scale_up_policy_arn
  scale_down_policy_arn       = module.ecs.scale_down_policy_arn
  common_tags                 = var.common_tags
  vpc_name                    = var.vpc_name
  cpu_high_period             = var.cpu_high_period
  cpu_high_threshold          = var.cpu_high_threshold
  cpu_low_period              = var.cpu_low_period
  cpu_low_threshold           = var.cpu_low_threshold
  cpu_high_evaluation_periods = var.cpu_high_evaluation_periods
  cpu_low_evaluation_periods  = var.cpu_low_evaluation_periods
}

*/


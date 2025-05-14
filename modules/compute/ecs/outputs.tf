output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "scale_up_policy_arn" {
  description = "The ARN of the ECS scale up policy"
  value       = aws_appautoscaling_policy.scale_up_policy.arn
}

output "scale_down_policy_arn" {
  description = "The ARN of the ECS scale down policy"
  value       = aws_appautoscaling_policy.scale_down_policy.arn
}
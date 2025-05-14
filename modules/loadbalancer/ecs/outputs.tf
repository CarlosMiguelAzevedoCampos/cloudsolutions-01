output "ecs_target_group_arn" {
  description = "The ARN of the ECS Target Group."
  value       = aws_lb_target_group.ecs_target_group.arn
}

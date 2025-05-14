output "launch_template_id" {
  description = "The ID of the Launch Template."
  value       = aws_launch_template.launch_template.id
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group."
  value       = aws_autoscaling_group.auto_scaling_group.name
}

output "scale_up_policy_arn" {
  description = "ARN of the Scale Up Policy"
  value       = aws_autoscaling_policy.scale_up.arn
}

output "scale_down_policy_arn" {
  description = "ARN of the Scale Down Policy"
  value       = aws_autoscaling_policy.scale_down.arn
}

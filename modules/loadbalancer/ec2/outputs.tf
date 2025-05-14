output "ec2_target_group_arn" {
  description = "The ARN of the EC2 Target Group."
  value       = aws_lb_target_group.ec2_target_group.arn
}

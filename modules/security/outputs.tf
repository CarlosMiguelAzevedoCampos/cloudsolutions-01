output "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer."
  value       = aws_security_group.alb_sg.id
}

output "app_sg_id" {
  description = "Security Group ID for the Application Instances."
  value       = aws_security_group.app_sg.id
}

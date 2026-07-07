output "target_group_arns" {
  description = "ARN of Target Group"
  value       = aws_lb_target_group.web_tg.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = aws_lb.web_lb.dns_name
}
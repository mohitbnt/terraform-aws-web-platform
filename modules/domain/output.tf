output "certificate_arn" {
  description = "ARN of the ACM certificate used by downstream modules."
  value       = aws_acm_certificate.web_certificate.arn
}
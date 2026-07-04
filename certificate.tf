# ACM Certificate
###############################################################
resource "aws_acm_certificate" "web_certificate" {

  domain_name = var.domain_name

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-certificate"
  }
}

# ACM Certificate Validation
###############################################################
resource "aws_acm_certificate_validation" "web_certificate_validation" {
  certificate_arn = aws_acm_certificate.web_certificate.arn
  validation_record_fqdns = [
    for record in cloudflare_dns_record.acm_validation : record.name
  ]
}
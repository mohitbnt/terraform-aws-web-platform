# Cloudflare provider initilization for module
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

}
# ACM Certificate
###############################################################
resource "aws_acm_certificate" "web_certificate" {

  domain_name = var.domain_name

  subject_alternative_names = ["*.${var.domain_name}"]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-certificate"
    }
  )
}
###############################################################
# ACM Validation Record
#
# ACM returns validation records only after the certificate request
# is created. Terraform cannot use these computed values as for_each
# keys during planning.
#
# For a root domain + wildcard certificate, ACM generates equivalent
# validation records. We therefore create a single validation record
# using a static for_each key and extract the matching record with one().
###############################################################

# ACM DNS Validation Records
###############################################################
resource "cloudflare_dns_record" "acm_validation" {
  # We use a single static key. This completely satisfies the plan phase, 
  # and ensures Cloudflare only ever creates EXACTLY ONE record (no duplicates).
  for_each = {
    "validation" = var.domain_name
  }

  zone_id = var.cloudflare_zone_id

  # one() extracts the single string out of the filtered tuple list, 
  # fulfilling Cloudflare's string requirements perfectly.
  name = one([
    for dvo in aws_acm_certificate.web_certificate.domain_validation_options : dvo.resource_record_name
    if dvo.domain_name == each.value
  ])

  content = one([
    for dvo in aws_acm_certificate.web_certificate.domain_validation_options : dvo.resource_record_value
    if dvo.domain_name == each.value
  ])

  type = one([
    for dvo in aws_acm_certificate.web_certificate.domain_validation_options : dvo.resource_record_type
    if dvo.domain_name == each.value
  ])

  ttl     = 1
  proxied = false
}

# ACM Certificate Validation
###############################################################
resource "aws_acm_certificate_validation" "web_certificate_validation" {
  certificate_arn         = aws_acm_certificate.web_certificate.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.acm_validation : record.name]
}


# Add DNS record for the website
resource "cloudflare_dns_record" "alb_dns" {
  for_each = toset(local.website_dns_records)

  zone_id = var.cloudflare_zone_id
  name    = each.value
  ttl     = 300
  type    = "CNAME"
  content = var.alb_dns_name
  proxied = false
}
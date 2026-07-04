# ACM DNS Validation Records
###############################################################

resource "cloudflare_dns_record" "acm_validation" {

  for_each = {
    for dvo in aws_acm_certificate.web_certificate.domain_validation_options :

    dvo.resource_record_name => {

      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }...
  }
  zone_id = var.cloudflare_zone_id

  name    = each.value[0].name
  content = each.value[0].value
  type    = each.value[0].type
  ttl     = 1
  proxied = false
}

# Add DNS record for the website 
resource "cloudflare_dns_record" "alb_dns" {
  for_each = toset(local.website_dns_records)

  zone_id = var.cloudflare_zone_id
  name    = each.value
  ttl     = 300
  type    = "CNAME"
  content = aws_lb.web_lb.dns_name
  proxied = false
}
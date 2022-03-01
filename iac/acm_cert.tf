resource "aws_acm_certificate" "app_frontend_cert" {
  domain_name       = "gitlab.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "${var.base_name}-${var.env}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "aws_provision_zones" {
  provider     = aws.network
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "gitlab_validate" {
  provider = aws.network
  for_each = {
    for dvo in aws_acm_certificate.app_frontend_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.aws_provision_zones.zone_id
}

resource "aws_acm_certificate_validation" "gitlab_validate" {
  certificate_arn         = aws_acm_certificate.app_frontend_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.gitlab_validate : record.fqdn]
}
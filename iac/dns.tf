data "aws_route53_zone" "public" {
  provider     = aws.network
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "gitlab_dns_record" {
  provider = aws.network
  zone_id  = data.aws_route53_zone.public.id
  name     = local.app_url
  type     = "A"

  alias {
    name                   = lower(aws_lb.gitlab.dns_name)
    zone_id                = aws_lb.gitlab.zone_id
    evaluate_target_health = true
  }
}

resource "aws_alb" "app" {}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.app.arn
  default_action {
    type = ""
  }
}

resource "aws_acm_certificate" "app" {}

resource "aws_acm_certificate_validation" "app" {
  certificate_arn = ""
}


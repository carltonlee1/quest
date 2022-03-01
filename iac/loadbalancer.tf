resource "aws_lb" "gitlab" {
  name               = "${var.base_name}-${var.env}-omnibus"
  load_balancer_type = "application"
  internal           = false
  subnets            = data.aws_subnet_ids.subnets.ids
  security_groups    = [aws_security_group.gitlab_alb.id]

  tags = merge({
    Name = "${var.base_name}-${var.env}-omnibus"
  }, var.custom_tags)
}

resource "aws_lb_target_group" "app" {
  vpc_id      = data.aws_vpc.vpc[0].id
  name        = "app"
  protocol    = "HTTPS"
  port        = 443
  target_type = "instance"

  health_check {
    protocol            = "HTTPS"
    port                = "traffic-port"
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200,302"
  }
}

resource "aws_lb_listener" "gitlab_https" {
  load_balancer_arn = aws_lb.gitlab.arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = aws_acm_certificate.app_frontend_cert.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

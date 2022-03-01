# Security group attached to app
resource "aws_security_group" "gitlab" {
  name   = "${var.base_name}-${var.env}-omnibus"
  vpc_id = data.aws_vpc.vpc[0].id

  tags = merge({
    Name = "${var.base_name}-${var.env}-omnibus"
  }, var.custom_tags)
}

resource "aws_security_group_rule" "outbound" {
  security_group_id = aws_security_group.gitlab.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound" {
  security_group_id = aws_security_group.gitlab.id
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0

  source_security_group_id = aws_security_group.app_alb.id
}


resource "tls_private_key" "gitlab" {
  algorithm = "RSA"
}

resource "aws_key_pair" "gitlab" {
  key_name   = "${var.base_name}-${var.env}-omnibus"
  public_key = tls_private_key.gitlab.public_key_openssh
}
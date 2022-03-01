resource "aws_instance" "gitlab" {
  ami                                  = var.app_ami_id
  instance_type                        = var.app_instance_type
  subnet_id                            = data.aws_subnet.subnet0[0].id
  vpc_security_group_ids               = [aws_security_group.gitlab.id]
  associate_public_ip_address          = true
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = aws_key_pair.gitlab.id
  iam_instance_profile                 = aws_iam_instance_profile.app_instance_profile.id
  user_data = templatefile("${path.module}/scripts/userdata.sh", {
  })

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = "true"
  }

  tags = merge({
    Name = "${var.base_name}-${var.env}-omnibus"
  }, var.custom_tags)
}

resource "aws_ebs_volume" "gitlab" {
  availability_zone = data.aws_subnet.subnet0[0].availability_zone
  size              = var.app_volume_size
}

resource "aws_volume_attachment" "app" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.gitlab.id
  instance_id = aws_instance.gitlab.id
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.gitlab.id
}


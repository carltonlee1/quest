resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.base_name}-${var.env}-omnibus"
  role = aws_iam_role.gitlab.name
}

resource "aws_iam_role" "gitlab" {
  name               = "app_iam_role"
  assume_role_policy = data.aws_iam_policy_document.app_assume_policy.json
}

data "aws_iam_policy_document" "app_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
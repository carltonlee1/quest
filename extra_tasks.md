## What would I add?

* WAF attached to ALB
* WAF rules for above
* Upload container to ECR
* Terraform ECS or EKS for app instead of an instance
* Add second provider for networking (route53 and ACM cert) to a separate account
* Tighter IAM Profile permissions
* Tighter Security Group rules
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.5.0"

  domain_name  = var.domain_name
  zone_id      = var.zone_id

  validation_method = var.validation_method

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  wait_for_validation = false
  tags = var.tags
}
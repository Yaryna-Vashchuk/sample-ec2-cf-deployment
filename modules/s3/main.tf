
module "origin_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = "${var.project_name}-${var.environment}-cdn-origin"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = false

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  tags = var.tags
}
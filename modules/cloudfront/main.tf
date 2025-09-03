data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "this" {
  name = "Managed-AllViewerExceptHostHeader"
}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 4.0"

  comment         = "${var.project_name}-${var.environment}-cdn"
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"
  http_version    = "http2and3"

  default_root_object = "index.html"

  create_origin_access_control = true
  origin_access_control = {
    s3 = {
      description      = ""
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    web = {
      domain_name              = var.domain_name
      origin_access_control_id = "s3"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "web"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id          = data.aws_cloudfront_cache_policy.this.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.this.id
  }

  custom_error_response = [
    {
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 0
    },
    {
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 0
    }
  ]

  viewer_certificate = var.acm_certificate_arn

  tags = var.tags
}

data "aws_iam_policy_document" "allow_cf_read" {
  statement {
    sid = "AllowCloudFrontRead"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = ["${var.s3_bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cdn.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = var.s3_bucket_arn
  policy = data.aws_iam_policy_document.allow_cf_read.json
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.origin_bucket.s3_bucket_arn
}
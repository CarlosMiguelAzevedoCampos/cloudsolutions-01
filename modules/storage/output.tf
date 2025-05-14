output "s3_bucket_name" {
  description = "The name of the S3 bucket created for application storage."
  value       = aws_s3_bucket.app_bucket.bucket
}
variable "s3_bucket_name" {
  description = "Prefix used for naming the S3 bucket (e.g., cloudsolutions-app-data)."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
}

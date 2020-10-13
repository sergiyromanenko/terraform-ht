/*output "terraform_state_s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the terraform_state S3 bucket"
}*/

output "wordpress_code_s3_bucket_arn" {
  value       = aws_s3_bucket.wordpress_code_bucket.arn
  description = "The ARN of the  wordpress_code S3 bucket"
}

output "wordpress_code_s3_bucket_name" {
  value       = aws_s3_bucket.wordpress_code_bucket.bucket
  description = "The name of the wordpress_code S3 bucket"
}

output "media_assets_bucket_s3_bucket_arn" {
  value       = aws_s3_bucket.media_assets_bucket.arn
  description = "The ARN of the media_assets S3 bucket"
}

output "media_assets_bucket_s3_bucket_domain_name" {
  value       = aws_s3_bucket.media_assets_bucket.bucket_domain_name
  description = "The domain_name of the media_assets S3 bucket"
}

output "media_assets_bucket_s3_bucket_name" {
  value       = aws_s3_bucket.media_assets_bucket.bucket
  description = "The name of the media_assets S3 bucket"
}

output "cloudfront_distribution_s3_media_assets_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The domain_name of cloudfront_distribution for the media_assets S3 bucket "
}
variable "env" {
  default = "test"
}

variable "project_name" {
  type        = string
}


/*variable "tf_state_s3_bucket_name" {
  description = "The name of the tf-state S3 bucket. Must be globally unique."
  type        = string
  default     = "tf-state-tolbr"
}*/

variable "tf_wordpress_code_s3_bucket_name" {
  description = "The name of the tf-wordpress-code S3 bucket. Must be globally unique."
  type        = string
  default     = "tf-wordpress-code-tolbr"
}

variable "tf_media_assets_s3_bucket_name" {
  description = "The name of the  tf-media-assets S3 bucket. Must be globally unique."
  type        = string
  default     = "tf-media-assets-tolbr"
}




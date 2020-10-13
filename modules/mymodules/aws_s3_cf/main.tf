#----------------------------------------------------------
#
# 1. Set up S3-buckets for Media Assets(make it public) and Wordpress code;
# 2. Create CloudFront distribution (Web);
#----------------------------------------------------------

resource "aws_s3_bucket" "wordpress_code_bucket" {
  bucket = var.tf_wordpress_code_s3_bucket_name
  acl    = "private"
  force_destroy = true

  tags= {
    Name        = "${var.project_name}-wordpress-code-bucket"
    Environment = "test"
  }
}


resource "aws_s3_bucket" "media_assets_bucket" {
  bucket = var.tf_media_assets_s3_bucket_name
  acl    = "public-read"
  force_destroy = true

  tags= {
    Name        = "${var.project_name}-media-assets-s3-bucket"
    Environment = "test"
  }
}


resource "aws_s3_bucket_policy" "media_assets_bucket" {
  bucket = aws_s3_bucket.media_assets_bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.tf_media_assets_s3_bucket_name}/*"
        }
    ]
}
POLICY
}


#------------CloudFront Distribution with an S3 media_assets_bucket origin ----------
locals {
  s3_origin_id = "myS3Origin"
}



resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.media_assets_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

/*    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }*/
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Some comment"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = [ "UA" ]
    }
  }

  tags = {
    Environment = var.env
    Project = var.project_name
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}



/*
resource "aws_s3_bucket" "terraform_state" {

  bucket = var.tf_state_s3_bucket_name

  // This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production
  // usage
  force_destroy = true

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}*/

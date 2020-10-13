variable "s3_media-assets_bucket_name" {
  type = string
}

variable "s3_wordpress_code_bucket_name" {
  type = string
}


variable "vpc-ec2-secgroup_id" {
  type = string
}

variable "subnet1_id" {
  type = string
}

variable "subnet2_id" {
  type = string
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_aws_key_pair_name" {
  default = "tf-ht-ec2-keypair"
}

variable "public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWFqeq+f9konUdlyGX91I0cKn7Vle5ZsM/IbBLKshLXYsAMm8VWucY9Iw5ltID9pBySBePKN4StoJX5QuxF6eMmZGsI1ZUKBktWenyuYoTCg6e1lKlZRnTyoLODTc4Y98ZvXgtiRKMZCNiKh5scCAHKelPOZjPrg/eoVfWTqaVxRqfXadCn/67Ui5Y2ECFX4iG2EbPCZEWKAbLhwF9MJxdjgUkEcPCjm3ZXVBnyGUhpirnYcaUu0uzKl9HW+VxNCyrqbxNjde+jJQkUP0tqJbSTeGXfN51aYg+JfiBLGRddPhztJiEun9/D3Ak4d62RlzJP3UKEdXRqp7/R2/AVkBzQug0HKsbApKE9Rk+D/yIkMWJXiLOkE8Vsj8HetBI9/YZh3HBFztbUyt8Deyw7DQ2qEe3RvUtoDjOfyDAxqSeAGQdB37QnsMVq6sGsf239XqjvEdSnrXzTb/claOH3IJqxwEmJSA1SPBBGvqTeNZt4Yctm4YjaMmLiJwLEhU2//k="
}


variable "rds_db_name" {
  type = string
}

variable "rds_db_password" {
  type = string
}

variable "rds_db_username" {
  type = string
}

variable "rds_db_address" {
  type = string
}

variable "rds_db_port" {
  type = number
}

variable "env" {
  default = "test"
}

variable "project_name" {
  type        = string
}

variable "project_owner" {
  default = "Project Owner"
}

variable "cloudfront_domain_name" {
  type = string
}




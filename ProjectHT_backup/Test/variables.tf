variable "region" {
  description = "AWS Region where to provision VPC Network"
  default     = "eu-central-1"
}

variable "env" {
  default = "test"
}

# home task project name
variable "project_name" {
  default = "ht-tf"
}

variable "project_owner" {
  default = "SR"
}

variable "rds_db-name" {
  default = "wordpressdb"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWFqeq+f9konUdlyGX91I0cKn7Vle5ZsM/IbBLKshLXYsAMm8VWucY9Iw5ltID9pBySBePKN4StoJX5QuxF6eMmZGsI1ZUKBktWenyuYoTCg6e1lKlZRnTyoLODTc4Y98ZvXgtiRKMZCNiKh5scCAHKelPOZjPrg/eoVfWTqaVxRqfXadCn/67Ui5Y2ECFX4iG2EbPCZEWKAbLhwF9MJxdjgUkEcPCjm3ZXVBnyGUhpirnYcaUu0uzKl9HW+VxNCyrqbxNjde+jJQkUP0tqJbSTeGXfN51aYg+JfiBLGRddPhztJiEun9/D3Ak4d62RlzJP3UKEdXRqp7/R2/AVkBzQug0HKsbApKE9Rk+D/yIkMWJXiLOkE8Vsj8HetBI9/YZh3HBFztbUyt8Deyw7DQ2qEe3RvUtoDjOfyDAxqSeAGQdB37QnsMVq6sGsf239XqjvEdSnrXzTb/claOH3IJqxwEmJSA1SPBBGvqTeNZt4Yctm4YjaMmLiJwLEhU2//k="
}
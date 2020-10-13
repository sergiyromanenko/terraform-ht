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
  #insert your pub key here for access to EC2 servers
  default = "ssh-rsa ...."
}
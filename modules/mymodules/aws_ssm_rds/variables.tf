
variable "env" {
  default = "test"
}

variable "project_name" {
  type = string
}

variable "project_owner" {
  default = "SR"
}

variable vpc_public_subnet_ids {
  type = list(string)
}

variable "name" {
  default = "My Name"
}

variable "vpc-rds-secgroup_id" {
  type = string
}

variable "rds_db_name" {
  type = string
}


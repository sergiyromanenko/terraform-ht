variable "project_name" {
  type  = string
}

variable "security_groups_id" {
  type = string
}


variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "aws_instances_subnet1_ids" {
  type = string
}

variable "aws_instances_subnet2_ids" {
  type = string
}
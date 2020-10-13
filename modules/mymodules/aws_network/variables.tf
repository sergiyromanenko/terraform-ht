variable "env" {
  default = "test"
}

variable "project_name" {
  type        = string
}

variable "project_owner" {
  default = "Project Owner"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}


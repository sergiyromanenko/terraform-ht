#----------------------------------------------------------
#
# 4.  Spin up RDS instance with Multi-AZ support. Create database;
#
# Generate Password for RDS MysqlDB
# Store Password in SSM Parameter Store
# Get Password from SSM Parameter Store
# Use Password in RDS
#
#----------------------------------------------------------


// Generate Password for RDS MysqlDB
resource "random_string" "rds_password" {
  length           = 12
  special          = false
  override_special = "!#$&"

  keepers = {
    kepeer1 = var.project_owner
  }
}

// Store Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_password" {
  name        = "/${var.project_name}/mysql"
  description = "Master Password for RDS MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

// Get Password from SSM Parameter Store
data "aws_ssm_parameter" "my_rds_password" {
  name       = "/${var.project_name}/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

#--------- this block needed for db_subnet_group_name parameter (VPC subnets) in next block "aws_db_instance"
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.vpc_public_subnet_ids

  tags = {
    Name = "My DB subnet group - project ${var.project_name}"
  }
}


resource "aws_db_instance" "default" {
  multi_az             = true
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.vpc-rds-secgroup_id]
  identifier           = "${var.project_name}-rds"
  allocated_storage    = 20
  storage_encrypted    = false
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.rds_db_name
  username             = "mysqladmin"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  deletion_protection  = false
}
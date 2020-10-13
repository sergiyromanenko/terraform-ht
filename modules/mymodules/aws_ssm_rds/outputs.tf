output "rds_db_password" {
  value = data.aws_ssm_parameter.my_rds_password.value
}

output "rds_db_username" {
  value = aws_db_instance.default.username
}

output "rds_db_address" {
  value = aws_db_instance.default.address
}

output "rds_db_name" {
  value = var.rds_db_name
}

output "rds_db_port" {
  value = aws_db_instance.default.port
}
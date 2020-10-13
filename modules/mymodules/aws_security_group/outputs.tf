output "vpc-ec2-secgroup" {
  value = aws_security_group.my_ec2_webserver.id
}

output "vpc-rds-secgroup" {
  value = aws_security_group.mysql_rds_server.id
}


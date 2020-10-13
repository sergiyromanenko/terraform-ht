output "ec2_server_subnet1_public_ip" {
  value = aws_instance.web_subnet1[0].public_ip
}

output "ec2_server_subnet2_public_ip" {
  value = aws_instance.web_subnet2[0].public_ip
}

output "aws_ami" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "aws_instances_subnet1_ids" {
  value = aws_instance.web_subnet1[0].id
}

output "aws_instances_subnet2_ids" {
  value = aws_instance.web_subnet2[0].id
}



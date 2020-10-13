output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "public_subnet1_id" {
  value = aws_subnet.public_subnets[0].id
}

output "public_subnet2_id" {
  value = aws_subnet.public_subnets[1].id
}


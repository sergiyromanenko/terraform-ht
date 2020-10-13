#---------  Networks  --------------

output "test_public_vpc_id" {
  value = module.aws-network.vpc_id
}

output "test_public_subnet_ids" {
  value = module.aws-network.public_subnet_ids
}

output "public_subnet1_id" {
  value = module.aws-network.public_subnet1_id
}

output "public_subnet2_id" {
  value = module.aws-network.public_subnet2_id
}

#------- Security Groups --------------

output "vpc-ec2-secgroup" {
  value = module.aws-sg.vpc-ec2-secgroup
}

output "vpc-rds-secgroup" {
  value = module.aws-sg.vpc-rds-secgroup
}


#------ S3 --------------

output "wordpress_code_s3_bucket_arn" {
  value       = module.aws-s3-cf.wordpress_code_s3_bucket_arn
  description = "The ARN of the  wordpress_code S3 bucket"
}

output "media_assets_bucket_s3_bucket_arn" {
  value       = module.aws-s3-cf.media_assets_bucket_s3_bucket_arn
  description = "The ARN of the media_assets S3 bucket"
}

output "media_assets_bucket_s3_bucket_domain_name" {
  value = module.aws-s3-cf.media_assets_bucket_s3_bucket_domain_name
  description = "The domain_name of the media_assets S3 bucket "
}

output "cloudfront_distribution_s3_media_assets_domain_name" {
  value       = module.aws-s3-cf.cloudfront_distribution_s3_media_assets_domain_name
  description = "The domain_name of cloudfront_distribution for the media_assets S3 bucket "
}

output "media_assets_bucket_s3_bucket_name" {
  value       = module.aws-s3-cf.media_assets_bucket_s3_bucket_name
  description = "The name of the media_assets S3 bucket"
}

#----------- EC2 outputs

output "ec2_server_subnet1_public_ip" {
  value        = module.aws-iam-ec2.ec2_server_subnet1_public_ip
  description = "The Ip of web server in subnet 1"
}


output "ec2_server_subnet2_public_ip" {
  value        = module.aws-iam-ec2.ec2_server_subnet2_public_ip
  description = "The Ip of web server in subnet 2"
}


#----------- DB outputs
output "rds_db_name" {
  value = module.aws-ssm-rds.rds_db_name
}

output "rds_db_username" {
  value = module.aws-ssm-rds.rds_db_username
}

output "rds_db_password" {
  value = module.aws-ssm-rds.rds_db_password
}


output "rds_db_address" {
  value = module.aws-ssm-rds.rds_db_address
}

output "rds_db_port" {
  value = module.aws-ssm-rds.rds_db_port
}

#-------------LoadBalancer dns name ------
output "alb_name" {
  value = module.aws-alb-tg.alb_dns_name
}


output "aws_instances_subnet1_ids" {
  value = module.aws-iam-ec2.aws_instances_subnet1_ids
}

output "aws_instances_subnet2_ids" {
  value = module.aws-iam-ec2.aws_instances_subnet2_ids
}


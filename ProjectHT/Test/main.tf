/*#----------------------------------------------------------
# My Terraform Home Task
#
# Use Our Terraform Module to create AWS VPC Network
# +0. Create VPC (Frankfurt):
# https://eu-central-1.console.aws.amazon.com/vpc/home?region=eu-central-1#vpcs:
# VPC-ht-tf
# 10.0.0.0/16
#
# Create two Public Subnets (Frankfurt):
# https://eu-central-1.console.aws.amazon.com/vpc/home?region=eu-central-1#subnets:SubnetId=subnet-0fc30696fcb072c87;sort=SubnetId
# 10.0.1.0/24   eu-central-1a  Subnet1-VPC-ht-tf
# 10.0.2.0/24   eu-central-1b  Subnet2-VPC-ht-tf
#
# Create Internet Gateway for internet access from public subnet:
# IGW-VPC-ht-tf
#
# and attach it to VPC
#
# In Route Tables create route table for public subnets in VPC:
# RouteTable1for-VPC-ht-tf (rtb-024b691e621dc658c)
#
# In Route Tables (Routes tab) add to Route table default route to 0.0.0.0/0 to intenet gateway
#
# In Subnets Edit route table association (change Route Table ID to new RouteTable1for-VPC-ht-tf)  for subnets:
# Subnet1-VPC-ht-tf
# Subnet1-VPC-ht-tf
#
#----------------------------------------------------------*/
provider "aws" {
  region = var.region
}

locals {
  full-project_name = "${var.env}-${var.project_name}"
}

module "aws-network" {
  source = "../../modules/mymodules/aws_network"
  project_name = local.full-project_name
  env = var.env
}

module "aws-sg" {
  source = "../../modules/mymodules/aws_security_group"
  vpc_id = module.aws-network.vpc_id
  env = var.env
}

module "aws-s3-cf" {
  source = "../../modules/mymodules/aws_s3_cf"
  env = var.env
  project_name = local.full-project_name
}

module "aws-ssm-rds" {
  source = "../../modules/mymodules/aws_ssm_rds"
  project_name = local.full-project_name
  project_owner = var.project_owner
  env = var.env
  # subnet1_id for ec2 creation
  vpc_public_subnet_ids = module.aws-network.public_subnet_ids
  # vpc-rds-secgroup_id for rds creation
  vpc-rds-secgroup_id = module.aws-sg.vpc-rds-secgroup
  rds_db_name = var.rds_db-name

  depends_on = [module.aws-network]
}

module "aws-iam-ec2" {
  source = "../../modules/mymodules/aws_iam_ec2"
  env = var.env
  project_name = local.full-project_name
  public_key = var.public_key
  s3_media-assets_bucket_name = module.aws-s3-cf.media_assets_bucket_s3_bucket_name
  s3_wordpress_code_bucket_name = module.aws-s3-cf.wordpress_code_s3_bucket_name
  # vpc-ec2-secgroup_id for ec2 creation
  vpc-ec2-secgroup_id = module.aws-sg.vpc-ec2-secgroup
  # subnet1_id for ec2 creation
  subnet1_id = module.aws-network.public_subnet1_id
  # subnet2_id for ec2 creation
  subnet2_id = module.aws-network.public_subnet2_id
  # db credentials for wordpress config (user_data)
  rds_db_password = module.aws-ssm-rds.rds_db_password
  rds_db_username = module.aws-ssm-rds.rds_db_username
  rds_db_address = module.aws-ssm-rds.rds_db_address
  rds_db_port = module.aws-ssm-rds.rds_db_port
  cloudfront_domain_name = module.aws-s3-cf.cloudfront_distribution_s3_media_assets_domain_name
  rds_db_name = module.aws-ssm-rds.rds_db_name

  depends_on = [module.aws-network, module.aws-ssm-rds, module.aws-sg]
}


#-------------------  AWS Load balancer

module "aws-alb-tg" {
  source = "../../modules/mymodules/aws_alb"
  vpc_id = module.aws-network.vpc_id
  security_groups_id = module.aws-sg.vpc-ec2-secgroup
  subnet_ids = module.aws-network.public_subnet_ids
  project_name = local.full-project_name
  depends_on = [ module.aws-network, module.aws-iam-ec2 ]
  aws_instances_subnet1_ids = module.aws-iam-ec2.aws_instances_subnet1_ids
  aws_instances_subnet2_ids = module.aws-iam-ec2.aws_instances_subnet2_ids

}


/*module "aws-asg" {
  source = "../../modules/mymodules/aws_asg"
  aws_ami = module.aws-iam-ec2.aws_ami
  project_name = local.full-project_name
  enable_autoscaling = false
  instance_type = "t2.micro"
  max_size = 0
  min_size = 0
  subnet_ids = module.aws-network.public_subnet_ids
  security_groups_id = module.aws-sg.vpc-ec2-secgroup
  depends_on = [ module.aws-network, module.aws-iam-ec2, module.aws-sg ]
}*/
#===============================================

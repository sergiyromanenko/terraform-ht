#https://medium.com/nonstopio/setting-up-terraform-development-environment-in-aws-25f8f6d0cf0d

# IAM Role for EC2 to access S3 bucket
# IAM Roles are used to granting the application access to AWS Services without using permanent credentials.

# ec2 user data for hard drive
data "template_file" "user_data_write_node" {
  template = file("templates/user_data_write_node.sh")
  vars = {
    rds_db_name = var.rds_db_name
    rds_db_password = var.rds_db_password
    rds_db_username = var.rds_db_username
    rds_db_address = var.rds_db_address
    rds_db_port = var.rds_db_port
    cloudfront_domain_name = var.cloudfront_domain_name
  }
}

data "template_file" "user_data_read_node" {
  template = file("templates/user_data_read_node.sh")
}

resource "aws_iam_role" "tf-ec2_s3_role" {
  name = "tf-ec2_s3_role"

  # assume_role_policy — The policy that grants an entity permission to assume the role.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# This is going to create IAM role but we can’t link this role to AWS instance and for that,
# we need EC2 instance Profile

resource "aws_iam_instance_profile" "ec2_s3_profile" {
name = "tf-ec2_s3_profile"
role = aws_iam_role.tf-ec2_s3_role.name
}


# Now if we execute the above code, we have Role and Instance Profile but with no permission.
# Next step is to add IAM Policies which allows EC2 instance
# to execute specific commands for eg: access to S3 Bucket

# Adding IAM Policies
# To give full access to S3 bucket

resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "tf-ec2_s3_policy"
  role = aws_iam_role.tf-ec2_s3_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${var.s3_media-assets_bucket_name}",
                "arn:aws:s3:::${var.s3_media-assets_bucket_name}/*",
                "arn:aws:s3:::${var.s3_wordpress_code_bucket_name}",
                "arn:aws:s3:::${var.s3_wordpress_code_bucket_name}/*"
            ]
    }
  ]
}
EOF
}

# Create and Integrate S3 and RDS with EC2

/*
######## RDS ############
resource "aws_db_instance" "db" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.username
  password               = var.password
  vpc_security_group_ids = [vpc-rds-secgroup_id]
  skip_final_snapshot    = true
}

*/

####### EC2 ############
/*
resource "aws_key_pair" "ec2-key" {
  key_name   = "deployer-key"
  public_key = var.public_key
}
*/



data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.ec2_aws_key_pair_name
  public_key = var.public_key
}

#------------ EC2 "WRITE NODE" -------------
resource "aws_instance" "web_subnet1" {
  count                  = 1
  subnet_id              = var.subnet1_id
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [var.vpc-ec2-secgroup_id]
  key_name               = var.ec2_aws_key_pair_name
  # iam instance profile for s3 access
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_profile.name
  user_data              = data.template_file.user_data_write_node.rendered
/*  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install httpd php php-mysql perl -y
echo "healthy" > /var/www/html/healthy.html
wget https://wordpress.org/wordpress-5.4.2.tar.gz
tar -xzf wordpress-5.4.2.tar.gz -C /var/www/html/ --strip=1
rm -rf wordpress-5.4.2.tar.gz
cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/username_here/${var.rds_db_username}/g" wp-config.php
sed -i "s/username_here/${var.rds_db_username}/g" wp-config.php
sed -i "s/password_here/${var.rds_db_password}/g" wp-config.php
sed -i "s/localhost/${var.rds_db_address}/g" wp-config.php
sed -i "s/put your unique phrase here/$(openssl rand -hex 48)/g" wp-config.php
chmod -R 755 /var/www/html/wp-content
chown -R apache:apache /var/www/html/wp-content
cat > /var/www/html/.htaccess << EOF
Options +FollowSymlinks
RewriteEngine on
rewriterule ^wp-content/uploads/(.*)$ http://${var.cloudfront_domain_name}/$1 [r=301,nc]
# BEGIN WordPress

# END WordPress
EOF
chkconfig httpd on
service httpd start
EOF*/


/*  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer in subnet 1 with local IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
echo "<br>Test of s3 media assets bucket access:  </br>" >> /var/www/html/index.html
aws s3 ls s3://${var.s3_media-assets_bucket_name} >> /var/www/html/index.html
echo "<br>Test of s3 wordpress code bucket access:  </br>" >> /var/www/html/index.html
aws s3 ls s3://${var.s3_wordpress_code_bucket_name} >> /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF*/

  tags = {
    Name  = "VPC-${var.project_name} WRITE NODE webserver-subnet1"
    Owner = "me"
  }
}


#------------ EC2 "READ NODES" subnet2 -------------
resource "aws_instance" "web_subnet2" {
  count                  = 1
  subnet_id              = var.subnet2_id
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [var.vpc-ec2-secgroup_id]
  key_name               = var.ec2_aws_key_pair_name
  # iam instance profile for s3 access
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_profile.name
  user_data              = data.template_file.user_data_read_node.rendered

  tags = {
    Name  = "VPC-${var.project_name} READ NODE webserver-subnet2"
    Owner = var.project_owner
  }
}

#----------------------------------------------------------------------
#
# 3. Create Security Groups for Web EC2 (in VPC) instances and RDS.
#
#_____________________________________________________________________

/*
data "aws_vpc" "selected" {
  tags = {
    Name = "${var.env}-VPC-ht-tf"
  }
}*/

#------------ SecGroup for EC2 webservers ----------------------

resource "aws_security_group" "my_ec2_webserver" {
  name = "VPC EC2 Security Group - HT TF"
  description = "Allow access to 22, 80 porttf s"
  vpc_id = var.vpc_id
#  vpc_id = data.aws_vpc.selected.id

  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.env}-VPC-ht-tf-EC2WebServers-SecGroup"
  }

}

#------------ DB SecGroup fro RDS ----------------------

resource "aws_security_group" "mysql_rds_server" {
  name = "VPC RDS Security Group - HT TF"
  description = "Allow access to 3306 port (RDS DB)"
#  vpc_id = data.aws_vpc.selected.id
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [ aws_security_group.my_ec2_webserver.id ]
  }

  tags = {
    Name  = "${var.env}-VPC-ht-tf-RDS-SecGroup"
  }

  depends_on = [aws_security_group.my_ec2_webserver]
}

#----------------

# ALB Security Group: Edit to restrict access to the application

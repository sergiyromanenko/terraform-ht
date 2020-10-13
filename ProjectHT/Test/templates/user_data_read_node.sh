sudo yum -y update
sudo amazon-linux-extras install -y php7.3
sudo yum -y install httpd mc
sudo service httpd start
sudo chkconfig httpd on
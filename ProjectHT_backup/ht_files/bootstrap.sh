#!/bin/bash
yum update -y
yum install httpd php php-mysql -y
echo "healthy" > /var/www/html/healthy.html
wget https://wordpress.org/wordpress-5.4.2.tar.gz
tar -xzf wordpress-5.4.2.tar.gz -C /var/www/html/ --strip=1
rm -rf wordpress-5.4.2.tar.gz
chmod -R 755 /var/www/html/wp-content
chown -R apache:apache /var/www/html/wp-content
cat > /var/www/html/.htaccess << EOF
Options +FollowSymlinks
RewriteEngine on
rewriterule ^wp-content/uploads/(.*)$ http://!!!{CloudFront Domain Name}}!!!/$1 [r=301,nc]

# BEGIN WordPress

# END WordPress
EOF
chkconfig httpd on
service httpd start
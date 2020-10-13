#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y php7.3
sudo yum install httpd mc -y
echo "healthy" > /var/www/html/healthy.html
wget https://wordpress.org/wordpress-5.4.2.tar.gz
tar -xzf wordpress-5.4.2.tar.gz -C /var/www/html/ --strip=1
rm -rf wordpress-5.4.2.tar.gz
cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${rds_db_name}/g" wp-config.php
sed -i "s/username_here/${rds_db_username}/g" wp-config.php
sed -i "s/password_here/${rds_db_password}/g" wp-config.php
sed -i "s/localhost/${rds_db_address}/g" wp-config.php
sed -i "s/put your unique phrase here/$(openssl rand -hex 48)/g" wp-config.php
sudo chmod -R 755 /var/www/html/wp-content
sudo chown -R apache:apache /var/www/html/wp-content
cat > /var/www/html/.htaccess << EOF
Options +FollowSymlinks
RewriteEngine on
RewriteBase /
RewriteRule ^wp-content/uploads/(.*)$ http://${cloudfront_domain_name}/\$1 [R=301,NC,L]
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

# END WordPress
EOF
sudo chkconfig httpd on
sudo service httpd start
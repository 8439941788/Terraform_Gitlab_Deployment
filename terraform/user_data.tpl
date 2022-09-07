#!/bin/bash
set -x

sudo apt-get update -y
sudo apt -y install software-properties-common
sudo apt-get update -y
sudo add-apt-repository ppa:ondrej/php
sudo apt-get upgrade -y
sudo apt install redis-server -y
sudo systemctl start redis
sudo systemctl enable redis
sudo sed -i "s|supervised no|supervised systemd|g"  /etc/redis/redis.conf
sudo systemctl restart redis
sudo chown -R redis:redis /var/log/redis
sudo chmod -R u+rwX,g+rwX,u+rx /var

sudo apt-get install git -y
password=${password}
DatabaseName=${DatabaseName}

sudo apt install apache2 -y
sudo rm -fr /etc/apache2/mods-enabled/dir.conf
sudo touch /etc/apache2/mods-enabled/dir.conf
sudo chmod 777 /etc/apache2/mods-enabled/dir.conf
sudo echo "
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>" > /etc/apache2/mods-enabled/dir.conf

export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $password"
sudo apt install mysql-server -y 

sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl start apache2
sudo systemctl enable apache2

sudo mysql -u root -p$password -e "CREATE DATABASE $DatabaseName;"
sudo mysql -u root -p$password -e "create user 'root'@'localhost' identified by 'Git@123$';"
sudo mysql -u root -p$password -e "grant all on *.* to 'root'@'localhost';"
sudo mysql -u root -p$password -e "FLUSH PRIVILEGES;"
sudo systemctl restart mysql

sudo apt install php7.4 -y && apt install php7.4-common php7.4-mysql php7.4-bcmath php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl -y && apt-get install php7.4-ldap -y
sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
sudo php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo composer 

sudo su 
cronjob="* * * * * cd /var/www/console-web && php artisan schedule:run >> /dev/null 2>&1"
(crontab -u root -l; echo "$cronjob" ) | crontab -u root -
sudo su ubuntu

touch /etc/apache2/sites-available/consoleweb.conf
sudo echo "
<VirtualHost *:80>
        ServerName IP
        DocumentRoot /var/www/console-web/public
        <Directory /var/www/console-web>
                AllowOverride All
        </Directory>
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/consoleweb.conf
ln -s /etc/apache2/sites-available/consoleweb.conf /etc/apache2/sites-enabled/
a2dissite 000-default.conf
a2ensite consoleweb.conf
a2enmod rewrite
sudo systemctl restart apache2
sudo cd /var/www
sudo nano php.sh
sudo echo "
#!/bin/bash
php artisan key:generate
chgrp -R www-data /var/www/console-web
chown -R www-data:www-data /var/www/console-web
chmod -R 775 /var/www/console-web/storage
chown -R www-data.www-data /var/www/console-web/storage
yes | composer install
yes | composer dump-autoload
yes | php artisan migrate:fresh
yes | php artisan serve " > /var/www/php.sh
sudo chmod 777 php.sh



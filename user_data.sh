#!/bin/bash
sudo su

yum update -y
yum upgrade -y
yum install -y docker
systemctl start docker
systemctl enable docker

yum install mariadb -y

mysql -h dbdesafio02.cby088cym3id.us-east-1.rds.amazonaws.com -P 3306 -u admin -ppKYuW9kbnWW04RDZZ3zp <<EOF
create database dbDesafio02;
exit;
EOF

mkdir -p /usr/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o /usr/lib/docker/cli-plugins/docker-compose
chmod +x /usr/lib/docker/cli-plugins/docker-compose

mkdir -p /home/ec2-user/wordpress
cd /home/ec2-user/wordpress

cat <<EOL > docker-compose.yml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: dbdesafio02.cby088cym3id.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: pKYuW9kbnWW04RDZZ3zp
      WORDPRESS_DB_NAME: dbDesafio02
    volumes:
      - wp-data:/var/www/html

volumes:
  wp-data:
EOL

usermod -aG docker ec2-user
newgrp docker
chown -R ec2-user:ec2-user /home/ec2-user/wordpress
docker compose -f /home/ec2-user/wordpress/docker-compose.yml up -d

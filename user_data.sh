#!/bin/bash
sudo su
yum update -y
yum upgrade -y
yum install -y docker
systemctl start docker
systemctl enable docker

mkdir -p /usr/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o /usr/lib/docker/cli-plugins/docker-compose
chmod +x /usr/lib/docker/cli-plugins/docker-compose

usermod -aG docker ec2-user

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
      WORDPRESS_DB_HOST: <RDS_ENDPOINT>
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wp-data:/var/www/html

volumes:
  wp-data:
EOL

chown -R ec2-user:ec2-user /home/ec2-user/wordpress

docker compose -f /home/ec2-user/wordpress/docker-compose.yml up -d

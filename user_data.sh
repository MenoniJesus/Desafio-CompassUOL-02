#!/bin/bash
sudo su
yum update -y
yum upgrade -y
yum install -y docker
systemctl start docker
systemctl enable docker

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose

chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

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
      WORDPRESS_DB_HOST: db-desafio02.cby088cym3id.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: 49561291
      WORDPRESS_DB_NAME: db-desafio02
    volumes:
      - wp-data:/var/www/html

volumes:
  wp-data:
EOL

docker compose up -d
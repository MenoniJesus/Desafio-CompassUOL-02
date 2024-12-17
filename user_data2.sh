#!/bin/bash
sudo su

yum update -y
yum upgrade -y
yum install -y docker
systemctl start docker
systemctl enable docker

yum install mariadb -y

mysql -h dbdesafio02.cby088cym3id.us-east-1.rds.amazonaws.com -P 3306 -u admin -p4956129lm <<EOF
create database dbDesafio02;
exit;
EOF

mkdir -p /home/ec2-user/wordpress
cd /home/ec2-user/wordpress

cat <<EOL > Dockerfile
FROM wordpress:latest

ENV WORDPRESS_DB_HOST=dbdesafio02.cby088cym3id.us-east-1.rds.amazonaws.com
ENV WORDPRESS_DB_USER=admin
ENV WORDPRESS_DB_PASSWORD=4956129lm
ENV WORDPRESS_DB_NAME=dbDesafio02

EXPOSE 80

CMD ["apache2-foreground"]
EOL

docker build -t wordpress-custom .
docker run -d -p 8080:80 --name wordpress-app wordpress-custom

usermod -aG docker ec2-user
newgrp docker
chown -R ec2-user:ec2-user /home/ec2-user/wordpress
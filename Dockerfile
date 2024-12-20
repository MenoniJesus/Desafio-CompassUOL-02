#!/bin/bash
sudo su

yum update -y
yum upgrade -y
yum install docker -y
yum install nfs-utils -y
systemctl start docker
systemctl enable docker

mkdir -p /mnt/efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <DNS_NAME>:/ /mnt/efs
chown ec2-user:ec2-user /mnt/efs

mkdir -p /home/ec2-user/wordpress
cd /home/ec2-user/wordpress

cat <<EOL > Dockerfile
FROM wordpress:latest

ENV WORDPRESS_DB_HOST=<WORDPRESS_DB_HOST>
ENV WORDPRESS_DB_USER=WORDPRESS_DB_USER>
ENV WORDPRESS_DB_PASSWORD=<WORDPRESS_DB_PASSWORD>
ENV WORDPRESS_DB_NAME=<WORDPRESS_DB_NAME>

EXPOSE 80

RUN echo "<?php \
http_response_code(200); \
header('Content-Type: application/json'); \
echo json_encode(['status' => 'OK', 'message' => 'Health check passed']); \
?>" > /var/www/html/healthcheck.php

CMD ["apache2-foreground"]
EOL

docker build --build-arg WORDPRESS_DB_HOST --build-arg WORDPRESS_DB_USER --build-arg WORDPRESS_DB_PASSWORD --build-arg WORDPRESS_DB_NAME -t wordpress-custom .

docker run -d -p 80:80 --name wordpress-app -v /mnt/efs:/var/www/html/ wordpress-custom

usermod -aG docker ec2-user
chown -R ec2-user:ec2-user /home/ec2-user/wordpress
newgrp docker

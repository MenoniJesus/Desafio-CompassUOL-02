#!/bin/bash
sudo su

yum update -y
yum upgrade -y
yum install docker -y
yum install nfs-utils -y
systemctl start docker
systemctl enable docker

mkdir -p /mnt/efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0005f10654a4e26d0.efs.us-east-1.amazonaws.com:/ /mnt/efs
chown ec2-user:ec2-user /mnt/efs

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

cat <<EOF > /mnt/efs/healthcheck.php
<?php
http_response_code(200);
header('Content-Type: application/json');
echo json_encode(["status" => "OK", "message" => "Health check passed"]);
exit;
?>
EOF

chown -R ec2-user:ec2-user /mnt/efs

docker build -t wordpress-custom .
docker run -d -p 80:80 --name wordpress-app -v /mnt/efs:/var/www/html/ wordpress-custom

usermod -aG docker ec2-user
chown -R ec2-user:ec2-user /home/ec2-user/wordpress
newgrp docker

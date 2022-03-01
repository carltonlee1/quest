#!/bin/bash
set -eu

yum install -y docker

service docker start
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

PUBLIC_HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

docker run -d \
  -h $PUBLIC_HOSTNAME \
  -p 443:3000 -p 80:80 -p 10022:22 \
  --name app \
  --restart always \
  gitlab/gitlab-ce:${gitlab_server_version}  # TODO docker build
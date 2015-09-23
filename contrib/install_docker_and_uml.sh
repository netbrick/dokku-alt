#!/bin/bash

set -xe

wget http://nginx.org/keys/nginx_signing.key -O - | apt-key add -
wget -qO- https://get.docker.com/gpg | sudo apt-key add -
wget -qO- https://get.docker.com/ | sh
apt-get update
mkdir -p /var/lib/docker
echo exit 101 | tee /usr/sbin/policy-rc.d
chmod +x /usr/sbin/policy-rc.d
apt-get install -y slirp lxc-docker aufs-tools cgroup-lite \
	apt-transport-https locales git make \
	curl software-properties-common \
	nginx dnsutils aufs-tools \
	dpkg-dev openssh-server man-db \
	apache2-utils
curl -sLo linux https://github.com/jpetazzo/sekexe/raw/master/uml
chmod +x linux

if mount | grep /dev/shm | grep noexec; then
	mount -o remount,exec /dev/shm
fi

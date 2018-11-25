#!/bin/bash
# https://stackoverflow.com/questions/27879713/is-it-ok-to-run-docker-from-inside-docker
yum install -y \ 
	yum-utils \
	device-mapper-persistent-data \
	lvm2

yum-config-manager \
	    --add-repo \
	        https://download.docker.com/linux/centos/docker-ce.repo

yum install docker-ce -y



yum clean all
rm -rf /var/cache/yum

#systemctl start docker
#docker run hello-world

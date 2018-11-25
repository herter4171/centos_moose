#!/bin/bash

cd /opt/moose

# Set package filename
PACKAGE_RPM=moose-environment_centos-7.5.1804_20181012_x86_64.rpm

# Download if it isn't available locally
if [ ! -f $PACKAGE_RPM ]; then
  wget http://www.mooseframework.org/moose_packages/$PACKAGE_RPM
fi

# Install with package manager
yum install $PACKAGE_RPM -y


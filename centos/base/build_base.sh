#!/bin/bash

yum install gcc \
	gcc-c++ \
	make \
	freeglut-devel\
	m4 \
	blas-devel \
	lapack-devel \
	gcc-gfortran \
	libX11-devel \
	vi \
	git \
	wget \
        tcl -y

yum clean all
rm -rf /var/cache/yum


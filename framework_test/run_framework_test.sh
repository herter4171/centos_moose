#!/bin/bash

cd /projects/moose/test
yum install tcl -y
source /opt/moose/environments/moose_profile
make -j 4
#./run_tests

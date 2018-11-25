#!/bin/bash

cd /app
git clone https://github.com/idaholab/moose.git --verbose
cd moose
git checkout master
git submodule init libmesh
git submodule update --recursive libmesh

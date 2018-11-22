#!/bin/bash

mv /app/moose /projects
cd /projects/moose/scripts

source /opt/moose/environments/moose_profile
./update_and_rebuild_libmesh.sh


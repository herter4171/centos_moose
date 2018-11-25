#!/bin/bash

cd $STACK_SRC
apk add curl git
curl_and_tar()
{
  res=$(curl -# -L -O $1)
  res="$res $(tar -xf "${1##*/}" -C $STACK_SRC)"
  printf "$res\n"
}

ls_curl_url="
https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
http://www.mpich.org/static/downloads/$MPICH_VERSION/mpich-$MPICH_VERSION.tar.gz
http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-$PETSC_VERSION.tar.gz
"

for url in $ls_curl_url; do
  {
    curl_and_tar $url
    if [ $(grep -c "gcc-$GCC_VERSION") > 0 ]; then
      cd $STACK_SRC/gcc-$GCC_VERSION
      ./contrib/download_prerequisites
    fi
  } &
done

cd /projects
if [ -d moose ]; then rm -rf moose; fi
git clone https://github.com/idaholab/moose.git
cd /projects/moose
git submodule init libmesh
git submodule update --recursive libmesh

wait

ls -l /projects

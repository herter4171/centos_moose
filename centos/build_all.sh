#!/bin/bash

dc_run_cmd()
{
  echo "CMD ARGS: $1"
  sudo docker-compose $1
}

dc_build_run_image()
{
  for cmd_str in build run ; do
    args="$cmd_str $1"
    dc_run_cmd "$args"
  done
}

# Set project path from this file's directory
export PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $PROJECT_PATH

# Set project name from current directory name
export PROJECT_NAMiE=${PWD##*/}

dc_build_run_image base

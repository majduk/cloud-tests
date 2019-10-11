#!/usr/bin/env bash
set -e
export PROJECT_DIR=~/tests
export IMAGES_DIR=~/images
export BASEDIR=$( dirname $0 )
export OUTPUT_DIR="~/tests-output"

export KEYPAIR=maas-keypair

if [ -z $OS_AUTH_URL ];then
  echo "No openstack credentials supplied"
  exit 1
fi
mkdir -p $IMAGES_DIR
mkdir -p $OUTPUT_DIR

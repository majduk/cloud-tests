#!/usr/bin/env bash
source $(dirname $0)/common.sh

declare -A images
images=(
  [cirros]="http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img"
  [bionic]="https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
)

for image in ${!images[@]}; do
  if [ ! -f $IMAGES_DIR/$image ];then 
    echo "Downloading image $image"
    wget -O $IMAGES_DIR/$image ${images[$image]}
  fi
  echo "Uploading to openstack"
  openstack image create --disk-format qcow2 \
  --file ~/images/$image \
  --public $image 
done

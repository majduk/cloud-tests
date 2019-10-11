#!/usr/bin/env bash
source $( dirname $0 )/common.sh

declare -A flavors
flavors=(
  [1]="--vcpus 1 --ram 512 --disk 10 m1.tiny"
  [2]="--vcpus 1 --ram 2048 --disk 20 m1.small"
  [3]="--vcpus 2 --ram 4096 --disk 40 m1.medium"
  [4]="--vcpus 4 --ram 8192 --disk 80 m1.large"
  [5]="--vcpus 8 --ram 16384 --disk 160 m1.xlarge"
)

for flavor in ${!flavors[@]}; do
  openstack flavor create ${flavors[$flavor]} --id $flavor
done

#!/usr/bin/env bash
source $( dirname $0 )/common.sh

if [ ! -z $KEYPAIR ]; then
  key_name="--key-name $KEYPAIR"	
fi
name=${INSTANCE_PREFIX:-test}
if [ -z $NETWORK ]; then
  echo "No network specified"
  exit 1
fi
flavor=${FLAVOR:-m1.tiny}
image=${IMAGE:-cirros}
availability_zone=""
if [ ! -z $ZONE ];then
  zone=${ZONE}
  availability_zone="--availability-zone=$zone"
  name="${name}-${zone}"
fi
if [ ! -z $HYPERVISOR ];then
  hypervisor=$HYPERVISOR
  availability_zone="${availability_zone}:$hypervisor"
  name="${name}-$hypervisor"
fi
if [ ! -z $USER_DATA ];then
  user_data="--user-data $USER_DATA"
fi
set -x
openstack server create \
  --image ${image} \
  --flavor ${flavor} \
  --network ${NETWORK} \
  $user_data \
  $key_name \
  $availability_zone \
  $name
set +x
instance_id=$( openstack server list -c ID -c Name -f value | \
grep "$name" | head -n 1 | cut -d " " -f 1 )
while true; do
  status=$( openstack server show $instance_id -c status -f value | head -n1 )
  echo "Instance $instance_id $name status $status"
  if [ $status == "ACTIVE" ];then
    openstack server show $instance_id --max-width 80
    exit 0
  elif [ $status == "ERROR" ];then
    openstack server show $instance_id --max-width 80
    exit 1
  else
    sleep 5
  fi
done

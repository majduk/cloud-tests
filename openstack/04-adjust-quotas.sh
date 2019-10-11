#!/usr/bin/env bash
source $( dirname $0 )/common.sh

ADMIN_PROJECT_ID=$(openstack project show admin --domain admin_domain \
	  -c id -f value)

openstack quota set --cores 100 ${ADMIN_PROJECT_ID}
openstack quota set --ram 102400 ${ADMIN_PROJECT_ID}
openstack quota set --instances 100 ${ADMIN_PROJECT_ID}


#!/usr/bin/env bash
source $( dirname $0 )/common.sh

openstack keypair create \
    --public-key $PROJECT_DIR/keys/maas_id_rsa.pub \
    ${KEYPAIR}

#!/bin/bash

#Azure settings
REGION="West Europe"
SERVICE=k8s-test
#USERPROFILE
VM_SIZE="Small"
CERT="$HOME/.ssh/id_rsa.pub"
CLUSTER_NAME=k8s-test
USER=core
WORKERS_ALREADY_PRESENT=2
MASTERS_ALREADY_PRESENT=1

SSH_PORT_START=2022
#Version of CoreOS to use, see: https://coreos.com/os/docs/latest/booting-on-azure.html
IMAGE="2b171e93f07c4903bcad35bda10acf22__CoreOS-Beta-991.2.0"


echo Fetching token
TOKEN=$(cat .discovery_token)
echo "Token: $TOKEN"
#escaping token for use with sed replace
TOKEN=$(echo "$TOKEN"|sed -e 's/[\/&]/\\&/g')
echo "Building template"

SSH_PORT=$(($SSH_PORT_START+$WORKERS_ALREADY_PRESENT+$MASTERS_ALREADY_PRESENT))

#Role is used for the metadata for fleet

ROLE=worker
HOSTNAME=$CLUSTER_NAME-$ROLE-$WORKERS_ALREADY_PRESENT
sed -e "s/<token>/$TOKEN/g" -e "s/<role>/$ROLE/g" cloud-config-template.yaml > .cloud-config.yaml
echo "Creating machine $HOSTNAME"

azure vm create --custom-data=.cloud-config.yaml --vm-size="$VM_SIZE" --ssh="$SSH_PORT" --ssh-cert="$CERT" --no-ssh-password --vm-name="$HOSTNAME" --location="$REGION" --connect="$SERVICE" $IMAGE $USER

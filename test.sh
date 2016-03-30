#!/bin/bash

REGION="West Europe"
SERVICE=k8s-test
#USERPROFILE
CERT="$HOME/.ssh/id_rsa.pub"
CLUSTER_NAME=k8s-test
NODES=3
SSH_PORT_START=2022
IMAGE="2b171e93f07c4903bcad35bda10acf22__CoreOS-Beta-991.2.0 core"
VM_SIZE="Small"

echo Fetching token
TOKEN=$(curl -s -w "\n" "https://discovery.etcd.io/new?size=$NODES")
echo "$TOKEN" > .discovery_token
echo "Token: $TOKEN"
#escaping token for use with sed replace
TOKEN=$(echo "$TOKEN"|sed -e 's/[\/&]/\\&/g')
echo "Building template"
sed -e "s/<token>/$TOKEN/g" cloud-config-template.yaml > .cloud-config.yaml

echo Creating service if it doesnt exist yet
azure service create --location="$REGION" $SERVICE 

#azure vm create --custom-data=.cloud-config.yaml --vm-size=Small --ssh=22 --ssh-cert="$CERT" --no-ssh-password --vm-name=node-1 --location="$REGION" $SERVICE 2b171e93f07c4903bcad35bda10acf22__CoreOS-Beta-991.2.0 core
SSH_PORT=$SSH_PORT_START
i=0
while [ $i -lt $NODES ]; do
	HOSTNAME=$CLUSTER_NAME-node-$i
	echo "Creating machine $HOSTNAME"
	echo "$SSH_PORT"
	azure vm create --custom-data=.cloud-config.yaml --vm-size="$VM_SIZE" --ssh="$SSH_PORT" --ssh-cert="$CERT" --no-ssh-password --vm-name="$HOSTNAME" --location="$REGION" --connect="$SERVICE" $IMAGE
	
	let SSH_PORT=SSH_PORT+1
	let i=i+1 
done
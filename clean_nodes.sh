#!/bin/bash

SERVICE=k8s-test
MASTER_FQDN="http://$SERVICE.cloudapp.net"
MASTER_FQDN_ESCAPED=$(echo "$MASTER_FQDN"|sed -e 's/[\/&]/\\&/g')


# Make network environment variables available on system

# Global units
fleetctl destroy setup-network-environment.service

# prerequisite for flanneld (obsolete now as its included in the unit file)
# /usr/bin/etcdctl set /coreos.com/network/config '{"Network":"10.244.0.0/16", "Backend": {"Type": "vxlan"}}'

fleetctl destroy kube-flanneld.service

# Master units
fleetctl destroy generate-serviceaccount-key.service
fleetctl destroy kube-apiserver.service
fleetctl destroy kube-controllermanager.service
fleetctl destroy kube-scheduler.service

# Worker units
fleetctl destroy kube-proxy.service
fleetctl destroy kube-kubelet.service


#kubectl create -f cluster/addons/dashboard/dashboard-controller.yaml --namespace=kube-system
#kubectl create -f cluster/addons/dashboard/dashboard-service.yaml --namespace=kube-system
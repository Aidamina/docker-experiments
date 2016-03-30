#!/bin/bash

SERVICE=k8s-test
MASTER_FQDN="http://$SERVICE.cloudapp.net"
MASTER_FQDN=$(echo "$MASTER_FQDN"|sed -e 's/[\/&]/\\&/g')


cd units
# Make network environment variables available on system

# Global units
fleetctl start setup-network-environment.service

# prerequisite for flanneld (obsolete now as its included in the unit file)
# /usr/bin/etcdctl set /coreos.com/network/config '{"Network":"10.244.0.0/16", "Backend": {"Type": "vxlan"}}'

fleetctl start kube-flanneld.service

# Master units
fleetctl start generate-serviceaccount-key.service
fleetctl start kube-apiserver.service
fleetctl start kube-controllermanager.service
fleetctl start kube-scheduler.service

# Worker units

sed -e "s/<master-private-ip>/$MASTER_FQDN/g" kube-proxy.template.service > kube-proxy.service
sed -e "s/<master-private-ip>/$MASTER_FQDN/g" kube-kubelet.template.service > kube-kubelet.service
fleetctl start kube-proxy.service
fleetctl start kube-kubelet.service
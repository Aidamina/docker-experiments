#!/bin/bash

SERVICE=k8s-test
MASTER_FQDN="http://$SERVICE.cloudapp.net"
MASTER_FQDN_ESCAPED=$(echo "$MASTER_FQDN"|sed -e 's/[\/&]/\\&/g')


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
fleetctl start kube-controller-manager.service
fleetctl start kube-scheduler.service

# Worker units

sed -e "s/<master-private-ip>/$MASTER_FQDN_ESCAPED/g" kube-proxy.template.service > kube-proxy.service
sed -e "s/<master-private-ip>/$MASTER_FQDN_ESCAPED/g" kube-kubelet.template.service > kube-kubelet.service
fleetctl start kube-proxy.service
fleetctl start kube-kubelet.service

curl -H "Content-Type: application/json" -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"kube-system"}}' "$MASTER_FQDN:8080/api/v1/namespaces"

#kubectl create -f cluster/addons/dashboard/dashboard-controller.yaml --namespace=kube-system
#kubectl create -f cluster/addons/dashboard/dashboard-service.yaml --namespace=kube-system
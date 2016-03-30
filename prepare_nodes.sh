#!/bin/bash

mkdir -p /etc/kubernetes/ssl

cd units
#Make network environment variables available on system
fleetctl start setup-network-environment.service
fleetctl start kube-flanneld.service
fleetctl start generate-serviceaccount-key.service


/usr/bin/etcdctl set /coreos.com/network/config '{"Network":"10.244.0.0/16", "Backend": {"Type": "vxlan"}}'
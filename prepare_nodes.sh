#!/bin/bash

mkdir -p /etc/kubernetes/ssl

#Make network environment variables available on system
fleetctl start units/setup-network-environment.service

etcdctl set /coreos.com/network/config '{ "Network": "10.1.0.0/16" }'
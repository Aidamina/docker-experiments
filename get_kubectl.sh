#!/bin/bash

curl -O https://storage.googleapis.com/kubernetes-release/release/v1.2.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /opt/bin/kubectl

export PATH="/opt/bin:$PATH"
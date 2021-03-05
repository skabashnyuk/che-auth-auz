#!/bin/bash

echo '============'
echo 'Make the certificate file available inside the minikube vm'
echo '============'
rm -rf ~/.minikube/files/var/lib/minikube/certs/
mkdir -p ~/.minikube/files/var/lib/minikube/certs/ && \
 cp -a ./ssl/* ~/.minikube/files/var/lib/minikube/certs/
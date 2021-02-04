#!/bin/bash

echo '============'
echo 'Create the minikube cluster.'
echo '============'

#minikube start --memory=4096 \
#  --extra-config=apiserver.authorization-mode=RBAC \
#  --extra-config=apiserver.oidc-issuer-url=https://dex.example.com:32000 \
#  --extra-config=apiserver.oidc-username-claim=email \
#  --extra-config=apiserver.oidc-ca-file=/var/lib/minikube/certs/ca.pem \
#  --extra-config=apiserver.oidc-client-id=dex-che \
#  --extra-config=apiserver.oidc-groups-claim=groups
#minikube start --memory=4096 \
#  --alsologtostderr -v=8  \
#  --extra-config=apiserver.authorization-mode=RBAC \
#  --extra-config=apiserver.oidc-issuer-url=https://dex.example.com:32000 \
#  --extra-config=apiserver.oidc-username-claim=email \
#  --extra-config=apiserver.oidc-ca-file=/var/lib/minikube/certs/ca.pem \
#  --extra-config=apiserver.oidc-client-id=dex-che \
#  --extra-config=apiserver.oidc-groups-claim=groups

minikube start \
  --extra-config=apiserver.authorization-mode=RBAC \
  --extra-config=apiserver.oidc-issuer-url=https://example.com \
  --extra-config=apiserver.oidc-username-claim=email \
  --extra-config=apiserver.oidc-client-id=kubernetes-local
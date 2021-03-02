#!/bin/bash
#   --extra-config=apiserver.authorization-mode=RBAC \
minikube start --memory=4096 \
  --extra-config=apiserver.oidc-issuer-url=https://dex.example.com:32000 \
  --extra-config=apiserver.oidc-username-claim=email \
  --extra-config=apiserver.oidc-ca-file=/var/lib/minikube/certs/ca.pem \
  --extra-config=apiserver.oidc-client-id=dex-che \
  --extra-config=apiserver.oidc-groups-claim=groups
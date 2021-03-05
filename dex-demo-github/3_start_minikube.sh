#!/bin/bash

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

#minikube start \
#  --extra-config=apiserver.authorization-mode=RBAC \
#  --extra-config=apiserver.oidc-issuer-url=https://example.com \
#  --extra-config=apiserver.oidc-username-claim=email \
#  --extra-config=apiserver.oidc-client-id=kubernetes-local

echo '============'
echo 'Starting minikube'
echo '============'

#minikube start start --memory=4096
minikube start --memory=4096 \
#  --embed-certs  \
  --extra-config=apiserver.oidc-issuer-url=https://dex.example.com:32000 \
  --extra-config=apiserver.oidc-username-claim=email \
  --extra-config=apiserver.oidc-ca-file=/var/lib/minikube/certs/ca.pem \
  --extra-config=apiserver.oidc-client-id=example-app  \
  --extra-config=apiserver.oidc-groups-claim=groups
minikube addons enable ingress
minikube ssh -- "echo '127.0.2.1 dex.example.com' | sudo tee -a /etc/hosts"

echo '============'
echo 'Deploying dex'
echo '============'

kubectl create namespace dex --dry-run=client -o yaml | kubectl apply -f -
#kubectl create secret tls dex.example.com.tls --cert=ssl/cert.pem --key=ssl/key.pem   -n dex
kubectl create secret tls dex.example.com.tls --cert=ssl/kube.crt --key=ssl/domain.key   -n dex

kubectl create secret generic github-client --from-literal=client-id="$DEX_GITHUB_CLIENT_ID" --from-literal=client-secret="$DEX_GITHUB_CLIENT_SECRET" -n dex
kubectl apply -f dex.yaml -n dex
kubectl rollout status deployment/dex -n dex
kubectl create clusterrolebinding github-feniix --clusterrole=cluster-admin --user=skabashniuk@redhat.com -n dex
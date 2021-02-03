#!/bin/bash

echo '============'
echo 'Deploying dex'
echo '============'

kubectl apply -f dex.yaml
kubectl rollout status deployment/dex
kubectl create clusterrolebinding github-feniix --clusterrole=cluster-admin --user=feniix@gmail.com
#!/bin/bash

echo '============'
echo 'Add `dex.example.com` to minikube"s `/etc/hosts'
echo '============'

minikube ssh -- "echo '127.0.2.1 dex.example.com' | sudo tee -a /etc/hosts"
#!/bin/bash

echo '============'
echo 'Add `dex.example.com` to `/etc/hosts'
echo '============'

sudo -v && echo $(minikube ip) dex.example.com | sudo tee -a /etc/hosts
#!/bin/bash

echo '============'
echo 'Running test app'
echo '============'

/Users/skabashn/dev/src/go/src/github.com/dexidp/dex/bin/example-app \
     --issuer=https://dex.example.com:32000  \
     --issuer-root-ca=/Users/skabashn/.minikube/files/var/lib/minikube/certs/ca.crt
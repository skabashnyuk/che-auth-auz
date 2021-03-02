#!/bin/bash

minikube start --memory=4096 \
--extra-config=apiserver.authorization-mode=RBAC
--extra-config=apiserver.oidc-issuer-url="https://accounts.google.com"
--extra-config=apiserver.oidc-client-id=176961660254-1tucokm01qv5ejrv8hri9hdabibfohfi.apps.googleusercontent.com
--extra-config=apiserver.oidc-username-claim=email

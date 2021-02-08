#!/usr/bin/env bash

set -euo pipefail

echo 'Add the github clientid='$DEX_GITHUB_CLIENT_ID' and clientsecret='$DEX_GITHUB_CLIENT_SECRET

kubectl create secret generic github-client --from-literal=client-id="$DEX_GITHUB_CLIENT_ID" --from-literal=client-secret="$DEX_GITHUB_CLIENT_SECRET" -n dex
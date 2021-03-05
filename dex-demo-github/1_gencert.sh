#!/bin/bash
rm -rf ./ssl
mkdir -p ssl

echo '============'
echo 'Creating the certificates for dex (it will create the necessary certs for the demo)'
echo '============'
cat << EOF > ssl/req.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = dex.example.com
EOF

openssl genrsa -out ssl/ca-key.pem 4096
openssl req -x509 -new -nodes -key ssl/ca-key.pem -sha256 -days 1024 -out ssl/ca.pem -subj "/CN=kube-ca"

openssl genrsa -out ssl/key.pem 2048
openssl req -new -sha256 -key ssl/key.pem -out ssl/csr.pem -subj "/CN=kube-ca" -config ssl/req.cnf
openssl x509 -req -in ssl/csr.pem -CA ssl/ca.pem -CAkey ssl/ca-key.pem -CAcreateserial -out ssl/cert.pem -days 365 -sha256 -extensions v3_req -extfile ssl/req.cnf

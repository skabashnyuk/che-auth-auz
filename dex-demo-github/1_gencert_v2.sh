#!/bin/bash
rm -rf ./ssl
mkdir -p ssl

echo '============'
echo 'Creating the certificates for dex (it will create the necessary certs for the demo)'
echo '============'


DOMAIN='dex.example.com'
DNS_ENTRIES=DNS:${DOMAIN},DNS:*.${DOMAIN},DNS:*.sharded.${DOMAIN}
CHE_CA_CN='Local Dex Signer'
CHE_CA_KEY_FILE='ssl/ca.key'
CHE_CA_CERT_FILE='ssl/ca.crt'
CHE_SERVER_ORG='Local Dex'
CHE_SERVER_KEY_FILE='ssl/domain.key'
CHE_SERVER_CERT_REQUEST_FILE='ssl/domain.csr'
CHE_SERVER_CERT_FILE='ssl/domain.crt'
# Figure out openssl configuration file location
OPENSSL_CNF='/etc/pki/tls/openssl.cnf'
if [ ! -f $OPENSSL_CNF ]; then
    OPENSSL_CNF='/etc/ssl/openssl.cnf'
fi
openssl genrsa -out $CHE_CA_KEY_FILE 4096
openssl req -new -x509 -nodes -key $CHE_CA_KEY_FILE -sha256 \
            -subj /CN="${CHE_CA_CN}" \
            -days 1024 \
            -reqexts SAN -extensions SAN \
            -config <(cat ${OPENSSL_CNF} <(printf '[SAN]\nbasicConstraints=critical, CA:TRUE\nkeyUsage=keyCertSign, cRLSign, digitalSignature')) \
            -outform PEM -out $CHE_CA_CERT_FILE
openssl genrsa -out $CHE_SERVER_KEY_FILE 2048
openssl req -new -sha256 -key $CHE_SERVER_KEY_FILE \
            -subj "/O=${CHE_SERVER_ORG}/CN=${DOMAIN}" \
            -reqexts SAN \
            -config <(cat $OPENSSL_CNF <(printf "\n[SAN]\nsubjectAltName=${DNS_ENTRIES}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=digitalSignature, keyEncipherment, keyAgreement, dataEncipherment\nextendedKeyUsage=serverAuth")) \
            -outform PEM -out $CHE_SERVER_CERT_REQUEST_FILE
openssl x509 -req -in $CHE_SERVER_CERT_REQUEST_FILE -CA $CHE_CA_CERT_FILE -CAkey $CHE_CA_KEY_FILE -CAcreateserial \
             -days 365 \
             -sha256 \
             -extfile <(printf "subjectAltName=${DNS_ENTRIES}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=digitalSignature, keyEncipherment, keyAgreement, dataEncipherment\nextendedKeyUsage=serverAuth") \
             -outform PEM -out $CHE_SERVER_CERT_FILE
cat $CHE_SERVER_CERT_FILE $CHE_CA_CERT_FILE > ssl/kube.crt
#oc create configmap custom-ca --from-file=ca-bundle.crt=ca.crt  -n openshift-config
#oc patch proxy/cluster     --type=merge      --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'
#cat domain.crt ca.crt > openshift.crt
#oc create secret tls certificate      --cert=openshift.crt      --key=domain.key      -n openshift-ingress
#oc patch ingresscontroller.operator default      --type=merge -p      '{"spec":{"defaultCertificate": {"name": "certificate"}}}' -n openshift-ingress-operator

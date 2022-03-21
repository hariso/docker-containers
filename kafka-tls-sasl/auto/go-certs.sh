#!/bin/bash

cd "$(dirname "$0")/../secrets/" || exit

dopenssl () {
    docker run -it --rm -v $(pwd):/out -w /out alpine/openssl "$@"
}

keytool -importkeystore -srckeystore kafka.broker.truststore.jks -destkeystore server.p12 -deststoretype PKCS12
openssl pkcs12 -in server.p12 -nokeys -out server.cer.pem

keytool -importkeystore -srckeystore kafka.broker.keystore.jks -destkeystore client.p12 -deststoretype PKCS12
openssl pkcs12 -in client.p12 -nokeys -out client.cer.pem
openssl pkcs12 -in client.p12 -nodes -nocerts -out client.key.pem
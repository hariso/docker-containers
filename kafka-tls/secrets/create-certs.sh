#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose \
    -o xtrace

dopenssl () {
    docker run -it --rm -v $(pwd):/out -w /out alpine/openssl "$@"
}

# Generate CA key
dopenssl req -new -x509 -keyout snakeoil-ca-1.key -out snakeoil-ca-1.crt -days 365 -subj '/CN=localhost/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US' -addext "subjectAltName=DNS:localhost"  -passin pass:confluent -passout pass:confluent


for i in broker1 client
do
	echo $i
	# Create keystores
	keytool -genkey -noprompt \
				 -alias $i \
				 -dname "CN=localhost, OU=TEST, O=CONFLUENT, L=PaloAlto, S=Ca, C=US" \
				 -ext "SAN=DNS:localhost" \
				 -keystore kafka.$i.keystore.jks \
				 -keyalg RSA \
				 -storepass confluent \
				 -keypass confluent

	# Create CSR, sign the key and import back into keystore
	keytool -keystore kafka.$i.keystore.jks -alias $i -certreq -file $i.csr -storepass confluent -keypass confluent

	dopenssl x509 -req -CA snakeoil-ca-1.crt -CAkey snakeoil-ca-1.key -in $i.csr -out $i-ca1-signed.crt -days 9999 -CAcreateserial -passin pass:confluent

	keytool -keystore kafka.$i.keystore.jks -alias CARoot -import -noprompt -file snakeoil-ca-1.crt -storepass confluent -keypass confluent

	keytool -keystore kafka.$i.keystore.jks -alias $i -import -noprompt -file $i-ca1-signed.crt -storepass confluent -keypass confluent

	# Create truststore and import the CA cert.
	keytool -keystore kafka.$i.truststore.jks -alias CARoot -import -noprompt -file snakeoil-ca-1.crt -storepass confluent -keypass confluent

  echo "confluent" > ${i}_sslkey_creds
  echo "confluent" > ${i}_keystore_creds
  echo "confluent" > ${i}_truststore_creds
done

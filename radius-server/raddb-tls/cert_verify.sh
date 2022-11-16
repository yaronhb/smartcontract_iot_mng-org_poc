#!/bin/bash

# ENDPOINT="1a88f2cc5ee868a6c5ba073b96ddd834a1d67cb46486e8460b99b44497b5d9d6"
ENDPOINT=$(cat /etc/raddb/endpoint_id)

## Debug
# /usr/bin/cat "$1" > /tmp/radiusd/tls_client_cert

tls_client_cert_pem="$1"

tls_client_cert_all_json=$(jc --x509-cert < "$tls_client_cert_pem")
if [ $? -ne 0 ]; then
    echo "X509 to JSON Decode error"
    exit 1
fi

user_id=$(jq '.[0].tbs_certificate.subject.user_id' < <(echo "$tls_client_cert_all_json"))
if [ $? -ne 0 ]; then
    echo "User-ID not found in ceritifcate"
    exit 1
fi
user_id=${user_id:1:64}


# redis_uri="redis://127.0.0.1:6379"
redis_uri=$(cat /etc/raddb/redis_uri)
key="endpoint_0x$ENDPOINT/tickets/employee_0x$user_id/cert"

tempfile=$(mktemp)
redis-cli -u "$redis_uri" --raw GET "$key" > "$tempfile"
if [ $? -ne 0 ]; then
    echo "Error with redis query"
    rm "$tempfile"
    exit 1
fi

openssl="/usr/bin/openssl"
ca_cert="$tempfile"

if ! $openssl verify -CAfile "$ca_cert" "$ca_cert" > /dev/null 2>&1; then
    echo "Invalid CA Certificate"
    rm "$tempfile"
    exit 1
fi

cert_in="$tls_client_cert_pem"

$openssl verify -CAfile "$ca_cert" "$cert_in"; err_code=$?

rm "$tempfile"

exit $err_code

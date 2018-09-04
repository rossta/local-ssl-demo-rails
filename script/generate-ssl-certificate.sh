#!/usr/bin/env bash

if [[ ! -n "$1" ]]; then
  echo "Argument 1 should be the domain name" 1>&2
  exit 1
fi

name=$1
mkdir -p config/ssl

openssl req \
  -new \
  -newkey rsa:2048 \
  -sha256 \
  -days 3650 \
  -nodes \
  -x509 \
  -keyout config/ssl/$name.key \
  -out config/ssl/$name.crt \
  -config <(cat <<-EOF
  [req]
  distinguished_name = req_distinguished_name
  x509_extensions = v3_req
  prompt = no
  [req_distinguished_name]
  CN = $name
  [v3_req]
  keyUsage = keyEncipherment, dataEncipherment
  extendedKeyUsage = serverAuth
  subjectAltName = @alt_names
  [alt_names]
  DNS.1 = $name
  DNS.2 = *.$name
EOF
)
echo "A wildcard self-signed SSL key/certificate pair has been generated for $name"

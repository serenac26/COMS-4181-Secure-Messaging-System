#!/bin/bash

# boromail should maybe copy this script and the CSR into ca directory before sandboxing

# input: username/password (?), CSR, public key (?)
# output: certificate

# TODO: add TLS+encryption+signing roles for usr_cert configuration

# client creates CSR with its private key:
# openssl req -config $cacnf -nodes \
#   -key $clientprivkey -out $clientreq

username=$1
clientreq=$2
#intermedcert=
#intermediatekey=
#cacnf=
#clientcert=

# CA signs certificate containing public key
openssl x509 -req -in $clientreq -CA $intermedcert -CAkey $intermdediatekey -days 365 \
    -extfile $cacnf -extensions usr_cert -CAcreateserial -out $clientcert


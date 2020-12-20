#!/bin/bash

[ -z "${1+xxx}" ] && echo "Dir not specified" && exit
[ -d $1 ] && echo "$1 exists" && exit

pwd=$(pwd)

mkdir "$1"
cd $1

mkdir server client

mkdir server/bin server/mail server/ca server/private
mkdir server/ca/certs server/ca/intermediate server/ca/newcerts
mkdir server/ca/intermediate/certs server/ca/intermediate/csr server/ca/intermediate/newcerts
mkdir server/private/intermediate server/private/root server/private/credentials

for f in /home/mailbox/*; do
    cred="$(python3 $pwd/crypt-pw.py ${f:14})"
    credarray=($cred)
    echo "$cred" >> creds.txt
    echo "${credarray[1]}" >> server/private/credentials/${f:14}.hashedpw
done

mkdir client/bin client/private 

for f in /home/mailbox/*; do
    mkdir "server/mail/${f:14}"
    mkdir "client/private/${f:14}"
done
#!/bin/bash
set -e

# Load env file
set -a
test -f $(dirname $0)/../containers/.env && source $(dirname $0)/../containers/.env
set +a

cd $(dirname $0)/../certificates

if [ -f $PROJECT_NAME.crt ]; then
    echo "Certificate already exists."
else
    subj="/C=CH/ST=FR/L=Fribourg/O=Liip/OU=Pontsun/CN=$PROJECT_NAME.$PROJECT_EXTENSION"

    openssl genrsa -out $PROJECT_NAME.rootCA.key 4096
    openssl req -x509 -new -nodes -key $PROJECT_NAME.rootCA.key -sha256 -days 1024 -out $PROJECT_NAME.rootCA.crt -subj "$subj"

    openssl genrsa -out $PROJECT_NAME.key 4096
    openssl req -new -sha256 -subj "$subj" -key $PROJECT_NAME.key -out $PROJECT_NAME.csr -config ../config/openssl.cnf
    openssl x509 -req -in $PROJECT_NAME.csr -CA $PROJECT_NAME.rootCA.crt -CAkey $PROJECT_NAME.rootCA.key -CAcreateserial -out $PROJECT_NAME.crt -days 365 -extensions v3_req -extfile ../config/openssl.cnf

    cat $PROJECT_NAME.crt $PROJECT_NAME.key > $PROJECT_NAME.pem
    chmod 600 $PROJECT_NAME.key $PROJECT_NAME.pem
fi

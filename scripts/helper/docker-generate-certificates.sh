#!/bin/bash
set -e

# Load env file
set -a
test -f $(dirname $0)/../../containers/.env && source $(dirname $0)/../../containers/.env
set +a

# check if there are certs in the local directory
cd /certs/
if [ -f $PROJECT_NAME.crt ] && [ -z $1 ]; then
    echo "Certificate already exists in local certificates directory."
else
    if [ -f $PROJECT_NAME.crt ]; then
        # get existing alt names from the current cert, so that we can reuse them
        EXISTING_ALT_NAMES=$(certtool -i < /certs/$PROJECT_NAME.crt  | grep DNSname | cut -f 2 -d ":"  | sed -e 's/^[[:space:]]*//')
        ALT_NAMES=${EXISTING_ALT_NAMES}
    else
        ALT_NAMES=$PROJECT_NAME.$PROJECT_EXTENSION
        ALT_NAMES=${ALT_NAMES}$'\n'*.$PROJECT_NAME.$PROJECT_EXTENSION
    fi
    # add additional altnames
    if [[ ! -z $1 ]]; then
        ALT_NAMES=${ALT_NAMES}$'\n'$1
        ALT_NAMES=${ALT_NAMES}$'\n'*.$1
    fi

    # sort them and make them uniq to avoid duplicates
    ALT_NAMES=$(echo $"${ALT_NAMES}" | sort | uniq)
    EXISTING_ALT_NAMES=$(echo $"${EXISTING_ALT_NAMES}" | sort | uniq)

    if [[ $ALT_NAMES == $EXISTING_ALT_NAMES ]]; then
        echo "Certificate wouldn't change, don't generate a new one."
        exit 0;
    fi

    I=1
    #write the correct config lines
    while read -r line; do
        if [[ ! -z $line ]]; then
        ALT_NAMES_CONFIG=$ALT_NAMES_CONFIG$'\n'"DNS.$I = $line"
        ((I++))
        fi
    done <<< "$ALT_NAMES"

    subj="/C=CH/ST=FR/L=Fribourg/O=Liip/CN=$PROJECT_NAME.$PROJECT_EXTENSION"
    # don't regenerate rootCA, if it already exists
    if [ ! -f $PROJECT_NAME.rootCA.key ]; then
        openssl genrsa -out $PROJECT_NAME.rootCA.key 4096
        openssl req -x509 -new -nodes -key $PROJECT_NAME.rootCA.key -sha256 -days 1024 -out $PROJECT_NAME.rootCA.crt -subj "$subj"
    fi
    openssl genrsa -out $PROJECT_NAME.key 4096
    openssl req -new -sha256 -subj "$subj" -key $PROJECT_NAME.key -out $PROJECT_NAME.csr -config  <(cat /generate/config/openssl.cnf <(printf "$ALT_NAMES_CONFIG"))
    openssl x509 -req -in $PROJECT_NAME.csr -CA $PROJECT_NAME.rootCA.crt -CAkey $PROJECT_NAME.rootCA.key -CAcreateserial -out $PROJECT_NAME.crt -days 365 -extensions v3_req -extfile  <(cat /generate/config/openssl.cnf <(printf "$ALT_NAMES_CONFIG"))

    cat $PROJECT_NAME.crt $PROJECT_NAME.key > $PROJECT_NAME.pem
    chmod 600 $PROJECT_NAME.key $PROJECT_NAME.pem
fi


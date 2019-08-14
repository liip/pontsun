#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/helper/env.sh

mkdir -p $PONTSUN_DIR_ETC/certificates/

docker run --rm -v $PONTSUN_DIR/:/generate/ -v $PONTSUN_DIR_ETC/certificates/:/certs/ -it liip/pontsun-helper:latest /generate/scripts/helper/docker-generate-certificates.sh $1
CERT_PATH=$PONTSUN_DIR_ETC/certificates/$PROJECT_NAME.rootCA.crt
# disable set -e, since which will return an exit code, when step is not installed
set +e
# check if step is installed and use that. https://smallstep.com/docs/cli/
STEP=$(which step)
set -e
if [[ ! -z $STEP ]]; then
    if ! $STEP certificate verify $CERT_PATH 2> /dev/null; then
        echo "Installing $CERT_PATH into your system truststore"
        $STEP certificate install -all $CERT_PATH
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then  # use direct OS X methods, if step isn't installed
    $PONTSUN_DIR/scripts/helper/install-cert-macos.sh $CERT_PATH
fi
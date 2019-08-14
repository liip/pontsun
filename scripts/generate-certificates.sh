#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/env.sh

mkdir -p $PONTSUN_DIR_ETC/certificates/

docker run --rm -v $DIR/../:/generate/ -v $PONTSUN_DIR_ETC/certificates/:/certs/ -it liip/pontsun-helper:latest /generate/scripts/helper/docker-generate-certificates.sh $1
if [[ "$OSTYPE" == "darwin"* ]]; then
    $DIR/install-cert-macos.sh $PONTSUN_DIR_ETC/certificates/$PROJECT_NAME.rootCA.crt
fi
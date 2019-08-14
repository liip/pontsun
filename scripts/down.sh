#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/helper/env.sh

cd $PONTSUN_DIR/containers/

docker-compose down

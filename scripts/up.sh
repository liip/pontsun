#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/helper/env.sh

cd $PONTSUN_DIR/containers/

SERVICES="traefik"

if [[ "$PONTSUN_PORTAINER" != "no" ]]; then
  SERVICES="$SERVICES portainer"
fi

echo "Starting pontsun services: $SERVICES"

docker-compose up -d $SERVICES

if ! ping -c 1 -t 2 traefik.$PROJECT_DOMAIN  > /dev/null 2>&1 ; then
    echo >&2 "!!!! traefik.$PROJECT_DOMAIN could not be resolved. You should fix this !!!!"
fi
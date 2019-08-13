#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/env.sh

cd $DIR/../containers/

SERVICES="traefik"

if [[ "$OSTYPE" == "darwin"* ]]; then
  SERVICES="$SERVICES sshagent"
fi

if [[ "$PONTSUN_DNS" != "no" ]]; then

  # check if no dns server is running
  if $DIR/check-dns.sh; then
    SERVICES="$SERVICES dns"
  else
    echo "Looks like your running a local DNS resolver already, not starting dns container"
  fi


fi

if [[ "$PONTSUN_PORTAINER" != "no" ]]; then
  SERVICES="$SERVICES portainer"
fi


echo "Starting pontsun services: $SERVICES"

docker-compose up -d $SERVICES

if ! ping -c 1 -t 2 $PROJECT_DOMAIN  > /dev/null 2>&1 ; then
    echo "!!!! $PROJECT_DOMAIN could not be resolved. You should fix this !!!!"
fi
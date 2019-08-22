#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PONTSUN_DNS=$(docker inspect -f '{{.State.Running}}' pontsun_dns 2> /dev/null || echo 'false')

if [[ $PONTSUN_DNS == 'true' ]]; then
    DOCKER_COMPOSE="docker-compose -f docker-compose.yml -f docker-compose.dns.yml"
    cd $DIR/../containers/
    if $DOCKER_COMPOSE exec dns ash -c "if [[ -f  /etc/dnsmasq.d/$1.conf ]]; then exit 1; fi; echo address=/$1/127.0.0.1 > /etc/dnsmasq.d/$1.conf"
    then
       $DOCKER_COMPOSE restart dns
    fi
else
    # no DNS container.
    # write it to system dnsmasq

    if [[ "$OSTYPE" == "darwin"* ]]; then
      ETC_PREFIX=$(brew --prefix)'/etc'
    else
      ETC_PREFIX='/etc'
    fi

    if [[ ! -d  $ETC_PREFIX/dnsmasq.d/ ]]; then
        RED='\033[0;31m'
        NC='\033[0m' # No Color

        printf "${RED}pontsun_dns is not running and can't find $ETC_PREFIX/dnsmasq.d${NC}\n"
        printf "Please install dnsmasq locally or start potsun_dns"
        exit 1
    fi

    if [[ ! -f  $ETC_PREFIX/dnsmasq.d/$1.conf ]]; then
      if [[ "$OSTYPE" == "darwin"* ]]; then
        echo address=/$1/127.0.0.1 > $ETC_PREFIX/dnsmasq.d/$1.conf
        echo 'strict-order' >> $ETC_PREFIX/dnsmasq.d/$1.conf
      else
        echo address=/$1/127.0.0.1 | sudo tee $ETC_PREFIX/dnsmasq.d/$1.conf
        echo 'strict-order' | sudo tee --append $ETC_PREFIX/dnsmasq.d/$1.conf
      fi
      echo "dnsmasq entry updated, you may restart it to take effect."
    else
      echo "No dnsmasq changes done, $ETC_PREFIX/dnsmasq.d/$1.conf already exists."
    fi
fi

if [[ "$OSTYPE" == "darwin"* ]] && [[ ! -f /etc/resolver/$1 ]]; then
    echo "Adding to /etc/resolver/$1"
    sudo mkdir -vp /etc/resolver
    sudo bash -c "echo 'nameserver 127.0.0.1' > /etc/resolver/$1"
fi

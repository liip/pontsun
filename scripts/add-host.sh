#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$PONTSUN_DNS" != "no" ]]; then
    cd $DIR/../containers/
    if docker-compose exec dns ash -c "if [[ -f  /etc/dnsmasq.d/$1.conf ]]; then exit 1; fi; echo address=/$1/127.0.0.1 > /etc/dnsmasq.d/$1.conf "
    then
        if [[ "$OSTYPE" == "darwin"* ]] && [[ ! -f /etc/resolver/$1 ]]; then
            echo "Adding to /etc/resolver/$1"
            sudo mkdir -vp /etc/resolver
            sudo bash -c "echo 'nameserver 127.0.0.1' > /etc/resolver/$1"
        fi
        docker-compose restart dns
    fi
else
    # no DNS container.
    # write it to global,
    # FIXME: also check with brew on OS X
    #untested
    if [[ -f  /etc/dnsmasq.d/$1.conf ]]; then exit 1; fi; echo address=/$1/127.0.0.1 > /etc/dnsmasq.d/$1.conf
    #maybe dnsmasq restart needed
fi
#!/bin/bash
set -e

# Load env file
set -a
test -f $(dirname $0)/../containers/.env && source $(dirname $0)/../containers/.env
set +a

add_dnsmasq_config () {
    if [ ! -d "$(brew --prefix)/etc/" ]; then
        mkdir -pv $(brew --prefix)/etc/
    fi

    echo -e "address=/$PROJECT_DOMAIN/127.0.0.1 \nstrict-order" > $(brew --prefix)/etc/dnsmasq.conf
}

start_dnsmasq_automatically () {
    if [ ! -f  /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist ]; then
        cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
        launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
    fi
}

configure_dnsmasq () {
    if [ ! -d  /etc/resolver ]; then
        mkdir -v /etc/resolver
    fi

    if [ -f /etc/resolver/$PROJECT_DOMAIN ]; then
        rm /etc/resolver/$PROJECT_DOMAIN
    fi

    echo "nameserver 127.0.0.1" > /etc/resolver/$PROJECT_DOMAIN &
    wait $!
}

restart_dnsmasq () {
    launchctl stop homebrew.mxcl.dnsmasq
    launchctl start homebrew.mxcl.dnsmasq
}

test_if_dnsmasq_is_working () {
    RED='\033[30;41m'
    GREEN='\033[30;42m'
    NC='\033[0m' # No Color

    sleep 1
    ping -c 1 testing.dnsmasq.$PROJECT_DOMAIN &> /dev/null &&
    echo -e "${GREEN} dnsmasq $PROJECT_DOMAIN is working" ||
    echo -e "${RED} Something went wrong dnsmasq $PROJECT_DOMAIN is not working!${NC}"
}

add_dnsmasq_config
start_dnsmasq_automatically
configure_dnsmasq
restart_dnsmasq
test_if_dnsmasq_is_working

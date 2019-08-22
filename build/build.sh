#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
docker build -t liip/pontsun-helper:latest helper
docker build -t liip/pontsun-dnsmasq:latest dnsmasq

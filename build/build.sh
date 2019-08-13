#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
docker build -t docker.gitlab.liip.ch/druids/docker-toolbox/pontsun-helper:latest helper
docker build -t docker.gitlab.liip.ch/druids/docker-toolbox/pontsun-dnsmasq:latest dnsmasq
#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PONTSUN_DIR=${PONTSUN_DIR:-$DIR/../}
export PONTSUN_DIR_ETC=${PONTSUN_DIR_ETC:-$PONTSUN_DIR/etc/}

# Load env file
set -a
# load env variables but only if not set already
test -f $PONTSUN_DIR/containers/.env && source <(grep -v '^\s*#' $PONTSUN_DIR/containers/.env | sed -E 's|^ *([^=]+)=(.*)$|: ${\1=\2}; export \1|g')


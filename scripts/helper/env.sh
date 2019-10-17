#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PONTSUN_DIR_REL=${PONTSUN_DIR:-$DIR/../../}
PONTSUN_DIR="$( cd ${PONTSUN_DIR_REL} && pwd )"
PONTSUN_DIR_ETC=${PONTSUN_DIR_ETC:-$PONTSUN_DIR/etc/}

# Load env file
set -a
# load env variables but only if not set already

if [[ ! -f $PONTSUN_DIR/containers/.env ]]; then
  RED='\033[0;31m'
  NC='\033[0m' # No Color

  printf "${RED}${PONTSUN_DIR}/containers/.env does not exist!${NC}\nPlease copy it with:\n"
  printf "cp ${PONTSUN_DIR}/containers/.env.example ${PONTSUN_DIR}/containers/.env\n"
  printf  "and adjust it.\n"
  exit 1
fi
test -f $PONTSUN_DIR/containers/.env && source <(grep -v '^\s*#' $PONTSUN_DIR/containers/.env | sed -E 's|^ *([^=]+)=(.*)$|: ${\1=\2}; export \1|g')


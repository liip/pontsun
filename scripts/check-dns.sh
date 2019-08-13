#!/usr/bin/env bash

# exit code 0, if most certainly  the pontsun dns should be used

# check if explicitely enabled via env variable
if [[ "$PONTSUN_DNS" == "yes" ]]; then
    exit 0
fi

# check if disabled via env variable
if [[ "$PONTSUN_DNS" == "no" ]]; then
    exit 1
fi

# check if some dns server is running locally on TCP (testing on UDP is difficult)
if nc -z localhost 53 2> /dev/null; then
   exit 2;
fi




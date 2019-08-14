#!/bin/sh
set -e

# base from https://gist.github.com/koop/84254d5214495e6fc49db3284c9b7772
# Usage
# $ ./install-cert-macos.sh "/path/to/cert"

CERT_PATH=$1

# First, grab the SHA-1 from the provided SSL cert.
CERT_SHA1=$(openssl x509 -in "$CERT_PATH" -sha1 -noout -fingerprint | cut -d "=" -f2 | sed "s/://g")

# Next, grab the SHA-1s of any standard.dev certs in the keychain.
# Don't return an error code if nothing is found.
EXISTING_CERT_SHAS=$(security find-certificate -a -c "$PROJECT_NAME.$PROJECT_EXTENSION" -Z /Library/Keychains/System.keychain | grep "SHA-1") || true
echo "$EXISTING_CERT_SHAS" | grep -q "$CERT_SHA1" || {
   echo "Installing $CERT_PATH into your Keychain"
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$CERT_PATH"
}
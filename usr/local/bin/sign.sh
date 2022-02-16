#!/bin/sh
CERT=/usr/local/etc/ssl/certs/poudriere.cert
KEY=/usr/local/etc/ssl/keys/poudriere.key
# shellcheck disable=SC2162
# shellcheck disable=SC3045
read -t 2 sum
[ -z "$sum" ] && exit 1
echo SIGNATURE
# shellcheck disable=SC3037
# shellcheck disable=SC2086
echo -n $sum | /usr/bin/openssl dgst -sign "$KEY" -sha256 -binary
echo
echo CERT
cat "$CERT"
echo END

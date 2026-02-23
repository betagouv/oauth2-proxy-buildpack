#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ -z ${PORT+x} ]; then echo "please set PORT"; exit 1; fi
if [ -z ${OAUTH2_PROXY_PROVIDER+x} ]; then echo "please set OAUTH2_PROXY_PROVIDER"; exit 1; fi
if [ -z ${OAUTH2_PROXY_CLIENT_ID+x} ]; then echo "please set OAUTH2_PROXY_CLIENT_ID"; exit 1; fi
if [ -z ${OAUTH2_PROXY_CLIENT_SECRET+x} ]; then echo "please set OAUTH2_PROXY_CLIENT_SECRET"; exit 1; fi
if [ -z ${OAUTH2_PROXY_COOKIE_SECRET+x} ]; then echo "please set OAUTH2_PROXY_COOKIE_SECRET"; exit 1; fi

# scalingo specific
OAUTH2_PROXY_HTTP_ADDRESS="${OAUTH2_PROXY_HTTP_ADDRESS:-http://:$PORT}"
export OAUTH2_PROXY_HTTP_ADDRESS

while IFS='=' read -r name value; do
    if [[ $name == OAUTH2_PROXY_* ]]; then
        export "$name"
    fi
done < <(env)

# Generate authenticated emails file if ALLOWED_EMAILS is set
if [ -n "${OAUTH2_ALLOWED_EMAILS:-}" ]; then
    EMAILS_FILE="/tmp/allowed_emails.txt"
    echo "$ALLOWED_EMAILS" | tr ',' '\n' > "$EMAILS_FILE"
    export OAUTH2_PROXY_AUTHENTICATED_EMAILS_FILE="$EMAILS_FILE"
    echo "configured authenticated emails file at $EMAILS_FILE"
fi

echo "starting oauth2-proxy..."
exec ./oauth2-proxy

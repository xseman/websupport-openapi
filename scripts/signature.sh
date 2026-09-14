#!/bin/bash

# Signed request example for the Websupport REST API v1
# (https://rest.websupport.sk/docs/v1.intro).
#
# Credentials are read from .env in the repository root (see .env.example),
# or from an already exported WS_API_KEY / WS_API_SECRET.
#
# Usage: ./scripts/signature.sh [path] [query]
#   ./scripts/signature.sh                       # GET /v1/user/self
#   ./scripts/signature.sh /v1/user/self/zone    # GET /v1/user/self/zone
#   ./scripts/signature.sh /v1/user/self/zone "?pagesize=1"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${WS_ENV_FILE:-$SCRIPT_DIR/../.env}"

if [ -f "$ENV_FILE" ]; then
	set -a
	# shellcheck disable=SC1090
	. "$ENV_FILE"
	set +a
fi

: "${WS_API_KEY:?WS_API_KEY is not set (create .env from .env.example)}"
: "${WS_API_SECRET:?WS_API_SECRET is not set (create .env from .env.example)}"

api="https://rest.websupport.sk"
method="GET"
path="${1:-/v1/user/self}"
query="${2:-}"

# Canonical request: "{method} {path} {unix timestamp}", signature = hex HMAC-SHA1 with the secret.
timestamp="$(date -u +%s)"
signature="$(printf '%s' "${method} ${path} ${timestamp}" | openssl dgst -sha1 -hmac "${WS_API_SECRET}" | awk '{print $NF}')"

curl -sS "${api}${path}${query}" \
	-u "${WS_API_KEY}:${signature}" \
	-H "Date: $(date -u -d "@${timestamp}" +%Y-%m-%dT%H:%M:%SZ)" \
	-H "Accept: application/json" \
	-H "Content-Type: application/json"
echo

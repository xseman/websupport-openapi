#!/bin/bash

# Validates openapi.yaml (API v1) and openapi.v2.yaml (API v2) with
# xseman/openapi-generator (`validate` subcommand).
#
# The generator binary is taken from $OPENAPI_GENERATOR, or `openapi-generator`
# on PATH. Install/build it from https://github.com/xseman/openapi-generator
# (`go install github.com/xseman/openapi-generator/cmd/openapi-generator@latest`).
#
# Note: the API really exposes concrete paths next to templated siblings
# (e.g. /user/{userId}/hosting/shell vs /user/{userId}/hosting/{idOrUuid},
# /user/{userId}/invoice/by-order/{orderId} vs /user/{userId}/invoice/{invoiceId}/pdf,
# /user/restorepass vs /user/{userId}). Those paths must not be renamed to make a
# linter happy. Likewise, only the response codes shown in the official docs are listed.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATOR="${OPENAPI_GENERATOR:-openapi-generator}"

if ! command -v "${GENERATOR}" >/dev/null 2>&1; then
	echo "openapi-generator not found (set OPENAPI_GENERATOR or install xseman/openapi-generator)" >&2
	exit 1
fi
if ! "${GENERATOR}" validate --help >/dev/null 2>&1; then
	echo "${GENERATOR} does not support 'validate'; rebuild xseman/openapi-generator from a current checkout" >&2
	exit 1
fi

for SPEC in "${SCRIPT_DIR}/../openapi.yaml" "${SCRIPT_DIR}/../openapi.v2.yaml"; do
	echo "==> openapi-generator validate: $(basename "$SPEC")"
	"${GENERATOR}" validate -i "$SPEC" --recommend
done

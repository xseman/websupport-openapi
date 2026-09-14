#!/bin/bash

# Mirrors the official documentation into this folder:
#   - v1 pages (docs/v1.*) and the v2 intro page, converted from HTML to markdown
#   - the official v2 OpenAPI file (v2.openapi.json), formatted with jq (4-space indent)

set -e
cd "$(dirname "$0")"

while read -r url; do
	[ -z "$url" ] && continue
	case "$url" in
		*/v2/docs/*) name="v2.$(basename "$url")" ;;
		*) name="$(basename "$url")" ;;
	esac
	wget -q --show-progress -O "$name.html" "$url"
	pandoc "$name.html" -o "$name.md" \
		--from html \
		--to markdown \
		--wrap=none \
		--strip-comments
	rm "$name.html"
done < downloads.txt

wget -q --show-progress -O v2.openapi.raw.json https://rest.websupport.sk/v2/docs/openapi.json
jq --indent 4 . v2.openapi.raw.json > v2.openapi.json
rm v2.openapi.raw.json

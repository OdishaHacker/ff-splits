#!/usr/bin/env bash
# ODISHA ff-splits — sha256 + version meta generator
# Downtwo.java sidecar JSON: {"v":"<version>","sha256":"<zip sha>"}
#
# Usage:  ./make_meta.sh <zip_file> <version>  >  out.json
# Example: ./make_meta.sh ffi.zip 1.134.1  >  ffi.json
#          ./make_meta.sh ffm.zip 1.134.1  >  ffm.json
#
# Release asset me zip aur uska <name>.json dono same tag ke neeche upload karo.
# Downtwo URL derive karta hai: <zip-url bina .zip>.json
set -euo pipefail

zip="$1"
ver="$2"

if [[ ! -f "$zip" ]]; then
    echo "ERROR: zip file nahi mila: $zip" >&2
    exit 1
fi

sha=$(sha256sum "$zip" | awk '{print $1}')
printf '{"v":"%s","sha256":"%s"}\n' "$ver" "$sha"

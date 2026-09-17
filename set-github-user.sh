#!/usr/bin/env bash
# Replace the YOUR-GITHUB-USERNAME placeholder in every server.json with a real
# GitHub login. Run once, before publishing to registry.modelcontextprotocol.io.
#
#   ./set-github-user.sh my-github-login
set -euo pipefail

if [ $# -ne 1 ] || [ -z "$1" ] || case "$1" in -*) true;; *) false;; esac; then
  echo "usage: $0 <github-username>" >&2
  exit 1
fi

USER_LOGIN="$1"
cd "$(dirname "$0")"

for f in */server.json; do
  tmp="$f.tmp"
  sed "s|YOUR-GITHUB-USERNAME|${USER_LOGIN}|g" "$f" > "$tmp"
  mv "$tmp" "$f"
  echo "updated $f"
done

echo
echo "Server names are now:"
grep -h '"name"' */server.json

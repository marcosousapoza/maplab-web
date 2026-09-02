#!/bin/sh
set -eu

case "${1:-}" in
  major|minor|patch) npm version "$1" --no-git-tag-version ;;
  *) printf 'Usage: %s major|minor|patch\n' "$0" >&2; exit 2 ;;
esac

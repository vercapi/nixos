#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
org_file="$repo_root/config.org"

if ! command -v emacs >/dev/null 2>&1; then
  echo "error: emacs is required to tangle $org_file" >&2
  exit 1
fi

if [[ ! -f "$org_file" ]]; then
  echo "error: missing org source file: $org_file" >&2
  exit 1
fi

emacs --batch --quick "$org_file" \
  --eval '(require (quote org))' \
  --funcall org-babel-tangle >/dev/null

echo "Tangled files from $org_file"

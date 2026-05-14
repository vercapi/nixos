#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
org_file="$repo_root/config.org"

postprocess_nix_file() {
  local file="$1"
  local tmp
  tmp="$(mktemp)"

  if ! awk '
    BEGIN {
      list_depth = 0
      previous_blank = 0
    }
    {
      sub(/[ \t]+$/, "", $0)
      is_blank = ($0 ~ /^[[:space:]]*$/)

      if (is_blank) {
        if (list_depth > 0 || previous_blank) {
          next
        }
        print ""
        previous_blank = 1
        next
      }

      previous_blank = 0
      print $0

      opens = gsub(/\[/, "[", $0)
      closes = gsub(/\]/, "]", $0)
      list_depth += opens - closes
      if (list_depth < 0) {
        list_depth = 0
      }
    }
  ' "$file" >"$tmp"; then
    rm -f "$tmp"
    return 1
  fi

  mv "$tmp" "$file"
}

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

postprocess_nix_file "$repo_root/flake.nix"
while IFS= read -r -d '' nix_file; do
  postprocess_nix_file "$nix_file"
done < <(find "$repo_root/hosts" "$repo_root/modules" -type f -name '*.nix' -print0)

echo "Tangled files from $org_file"

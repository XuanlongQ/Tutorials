#!/usr/bin/env bash
# Build every slides.md in the repo into HTML + PDF, next to its source file.
# Usage: npm run build:slides
set -euo pipefail
cd "$(dirname "$0")/.."

if ! npx --no-install @marp-team/marp-cli --version >/dev/null 2>&1; then
  echo "marp-cli is not installed. Run: npm install" >&2
  exit 1
fi

find . -name 'slides.md' -not -path './node_modules/*' -print0 | while IFS= read -r -d '' src; do
  dir=$(dirname "$src")
  echo "» $src"
  # </dev/null: marp-cli treats non-TTY stdin as an extra markdown input,
  # and the find pipe would otherwise be inherited here.
  npx @marp-team/marp-cli "$src" --html --allow-local-files --theme-set assets/themes -o "$dir/slides.html" </dev/null
  npx @marp-team/marp-cli "$src" --pdf  --allow-local-files --theme-set assets/themes -o "$dir/slides.pdf" </dev/null
done

echo "Done."

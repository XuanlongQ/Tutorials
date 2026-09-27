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
  npx @marp-team/marp-cli "$src" --html --allow-local-files --theme-set assets/themes -o "$dir/slides.html"
  npx @marp-team/marp-cli "$src" --pdf  --allow-local-files --theme-set assets/themes -o "$dir/slides.pdf"
done

echo "Done."

#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

out="index.html"

# collect only top-level non-hidden directories, exclude scripts, .github, node_modules
mapfile -t dirs < <(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name 'scripts' ! -name '.github' ! -name 'node_modules' -printf '%P\n' | sort)

cat > "$out" <<'HTML'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Redirects</title>
<style>
  body { font-family: system-ui, -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; padding: 24px; }
  ul { list-style: none; padding: 0; }
  li { margin: 8px 0; }
  a { color: #0366d6; text-decoration: none; }
  a:hover { text-decoration: underline; }
</style>
</head>
<body>
<h1>Redirects</h1>
<ul>
HTML

for d in "${dirs[@]}"; do
  printf '  <li><a href="%s/">%s</a></li>\n' "$d" "$d" >> "$out"
done

cat >> "$out" <<'HTML'
</ul>
</body>
</html>
HTML

echo "Wrote $out with ${#dirs[@]} entries."

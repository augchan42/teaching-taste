#!/usr/bin/env bash
# Build the backup PDF: one 16:9 page per slide.
#
# Use it if the laptop, the browser or the venue network lets you down.
# The deck itself stays the source of truth — this only reads it.
#
# Chrome embeds WebP images without compression, which made a 49MB file.
# So the build works on a copy, with the images re-encoded as JPEG. The print
# stylesheet inside teaching-taste.html does the rest.
#
#   ./build-pdf.sh        writes teaching-taste-slides.pdf
#
set -euo pipefail

cd "$(dirname "$0")"
OUT="teaching-taste-slides.pdf"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

CHROME="$(command -v google-chrome || command -v google-chrome-stable || command -v chromium || true)"
if [ -z "$CHROME" ]; then
  echo "Need Chrome or Chromium on PATH." >&2
  exit 1
fi

echo "Staging a copy…"
cp -r fonts img ./*.webp ./*.png teaching-taste.html "$WORK/"

echo "Re-encoding images as JPEG…"
python3 - "$WORK" <<'PY'
from PIL import Image
import glob, os, sys

work = sys.argv[1]
swapped = []
for src in glob.glob(work + '/img/*.webp') + glob.glob(work + '/*.webp'):
    im = Image.open(src).convert('RGB')
    if im.width > 1920:
        im = im.resize((1920, round(im.height * 1920 / im.width)), Image.LANCZOS)
    dst = src[:-5] + '.jpg'
    im.save(dst, 'JPEG', quality=85, optimize=True)
    swapped.append((os.path.relpath(src, work), os.path.relpath(dst, work)))
    os.remove(src)

page = work + '/teaching-taste.html'
html = open(page, encoding='utf-8').read()
for old, new in swapped:
    html = html.replace(old, new)
open(page, 'w', encoding='utf-8').write(html)
print(f"  {len(swapped)} images")
PY

echo "Printing…"
"$CHROME" --headless=new --disable-gpu --no-sandbox \
  --run-all-compositor-stages-before-draw \
  --virtual-time-budget=20000 \
  --no-pdf-header-footer \
  --print-to-pdf="$PWD/$OUT" \
  "file://$WORK/teaching-taste.html" 2>/dev/null

echo "Wrote $OUT — $(du -h "$OUT" | cut -f1), $(pdfinfo "$OUT" | awk '/^Pages/{print $2}') pages"

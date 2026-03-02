#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/gen_thumbnail.sh epXX "Titolo riga 1" "Sottotitolo riga 2 (facolt.)"
# Output:
#   assets/thumbnails/epXX/epXX-thumb.png

EP="${1:-}"
TITLE="${2:-}"
SUBTITLE="${3:-}"

if [[ -z "${EP}" || -z "${TITLE}" ]]; then
  echo "Uso: $0 epXX \"Titolo\" \"Sottotitolo (facoltativo)\""
  exit 1
fi

OUTDIR="assets/thumbnails/${EP}"
OUTFILE="${OUTDIR}/${EP}-thumb.png"

# ── Command detection: prefer 'magick' (IM v7), fallback 'convert'
IM_CMD=""
if command -v magick >/dev/null 2>&1; then
  IM_CMD="magick"
elif command -v convert >/dev/null 2>&1; then
  IM_CMD="convert"
else
  echo "❌ ImageMagick non trovato. Installa con:"
  echo "   macOS: brew install imagemagick"
  echo "   Debian/Ubuntu: sudo apt-get update && sudo apt-get install -y imagemagick"
  exit 1
fi

# ── Font selection (macOS vs Linux)
OS="$(uname -s || echo unknown)"
FONT_REG=""
FONT_BOLD=""

if [[ "$OS" == "Darwin" ]]; then
  # macOS: usa Arial (presenti quasi sempre)
  # Nota: Helvetica.ttc può dare problemi; Arial .ttf è più “sicuro”.
  FONT_REG="/Library/Fonts/Arial Unicode.ttf"
  FONT_BOLD="/Library/Fonts/Arial Unicode.ttf"
  if [[ ! -f "$FONT_REG" || ! -f "$FONT_BOLD" ]]; then
    echo "⚠️  Font Arial non trovati in /Library/Fonts. Provo senza path (potrebbe fallire):"
    FONT_REG="Arial"
    FONT_BOLD="Arial-Bold"
  fi
else
  # Linux runner: DejaVu è generalmente installato
  FONT_REG="DejaVu-Sans"
  FONT_BOLD="DejaVu-Sans-Bold"
fi

# ── Stile grafico (modificabile)
BG_COLOR="#0e1116"           # sfondo scuro
ACCENT="#00d084"             # verde VBR
TEXT_COLOR="#ffffff"         # testo
BOX_COLOR="rgba(0,0,0,0.45)" # riquadro trasparente

mkdir -p "$OUTDIR"

# Base 1280x720 + barra inferiore
$IM_CMD -size 1280x720 xc:"$BG_COLOR" \
  -fill "$ACCENT" -draw "rectangle 0,650 1280,720" \
  "$OUTFILE"

# Box trasparente centrale per il testo
$IM_CMD "$OUTFILE" \
  -fill "$BOX_COLOR" -draw "rectangle 0,200 1280,520" \
  "$OUTFILE"

# Titolo (centrato)
$IM_CMD "$OUTFILE" \
  -gravity North \
  -font "$FONT_BOLD" -pointsize 84 -fill "$TEXT_COLOR" \
  -annotate +0+240 "$TITLE" \
  "$OUTFILE" || {
    echo "⚠️  Problema con il font $FONT_BOLD. Riprovo senza path…"
    $IM_CMD "$OUTFILE" \
      -gravity North \
      -pointsize 84 -fill "$TEXT_COLOR" \
      -annotate +0+240 "$TITLE" \
      "$OUTFILE"
  }

# Sottotitolo (se presente)
if [[ -n "${SUBTITLE:-}" ]]; then
  $IM_CMD "$OUTFILE" \
    -gravity North \
    -font "$FONT_REG" -pointsize 48 -fill "$TEXT_COLOR" \
    -annotate +0+360 "$SUBTITLE" \
    "$OUTFILE" || {
      echo "⚠️  Problema con il font $FONT_REG. Riprovo senza path…"
      $IM_CMD "$OUTFILE" \
        -gravity North \
        -pointsize 48 -fill "$TEXT_COLOR" \
        -annotate +0+360 "$SUBTITLE" \
        "$OUTFILE"
    }
fi

# Badge episodio in alto a sinistra
EP_BADGE="$(echo "$EP" | tr '[:lower:]' '[:upper:]')"
$IM_CMD "$OUTFILE" \
  -gravity NorthWest \
  -font "$FONT_BOLD" -pointsize 36 -fill "$ACCENT" \
  -annotate +40+40 "$EP_BADGE" \
  "$OUTFILE" || true

echo "✅ Thumbnail generata: $OUTFILE"

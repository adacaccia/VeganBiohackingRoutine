#!/usr/bin/env bash
set -euo pipefail

MARKERS_DIR="S01_Intro/metadata"
MARKER_GLOB="${MARKERS_DIR}/ep??-thumb.txt"

echo "▶ Cerco marker thumbnail in: ${MARKER_GLOB}"
shopt -s nullglob
FOUND=0
for MARKER in ${MARKER_GLOB}; do
  EPBASENAME="$(basename "$MARKER")"      # es. ep05-thumb.txt
  EP="${EPBASENAME%%-*}"                  # -> ep05
  TITLE="$(sed -n '1p' "$MARKER" | tr -d '\r' || true)"
  SUBTITLE="$(sed -n '2p' "$MARKER" | tr -d '\r' || true)"

  if [[ -z "${TITLE}" ]]; then
    echo "::warning ::${MARKER}: titolo vuoto (riga 1). Salto."
    continue
  fi

  echo "   • Genero thumbnail per ${EP} → titolo='${TITLE}'  sottotitolo='${SUBTITLE}'"
  ./scripts/gen_thumbnail.sh "${EP}" "${TITLE}" "${SUBTITLE:-}"

  OUTFILE="assets/thumbnails/${EP}/${EP}-thumb.png"
  if [[ -f "$OUTFILE" ]]; then
    echo "     ✓ Creato/aggiornato: ${OUTFILE}"
    FOUND=$((FOUND+1))
  else
    echo "::warning ::Thumbnail non trovata dopo la generazione: ${OUTFILE}"
  fi
done

if (( FOUND == 0 )); then
  echo "ℹ️  Nessun marker trovato o nessuna thumbnail generata."
else
  echo "▶ Thumbnail generate/aggiornate: ${FOUND}"
fi

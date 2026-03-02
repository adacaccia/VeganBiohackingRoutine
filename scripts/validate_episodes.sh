#!/usr/bin/env bash
set -euo pipefail

echo "▶ Validazione episodi & asset"

EP_DIR="S01_Intro"
ASSET_BASE="assets/images/processed"

MISSING=0

# 1) Verifica index
if [[ ! -f "assets/INDEX.md" ]]; then
  echo "::warning ::assets/INDEX.md mancante (esegui ./scripts/asset_sync.sh)"
fi

# 2) Per ciascun epXX-*.md verifica esistenza cartella asset processed corrispondente
shopt -s nullglob
for EPFILE in ${EP_DIR}/ep??-*.md; do
  EPBASENAME="$(basename "$EPFILE")"
  EP="${EPBASENAME%%-*}"       # es. ep03-sonno... -> ep03
  EP_ASSET_DIR="${ASSET_BASE}/${EP}"

  if [[ ! -d "$EP_ASSET_DIR" ]]; then
    echo "::warning ::Manca la cartella assets per ${EP} -> crea ${EP_ASSET_DIR}"
    MISSING=$((MISSING+1))
  else
    # Se la cartella esiste ma è vuota, verifica se c'è almeno .gitkeep
    if [[ -z "$(ls -A "$EP_ASSET_DIR")" ]]; then
      echo "::notice ::${EP_ASSET_DIR} esiste ma è vuota (ok se l'episodio non ha ancora asset)"
    fi
  fi
done

echo "▶ Verifica completata. Episodi senza cartella assets: $MISSING"

#!/usr/bin/env bash

set -e

echo ""
echo "──────────────────────────────────────────────"
echo "  VBR ASSET SYNC — gestione asset & gitkeep"
echo "──────────────────────────────────────────────"
echo ""

BASE_DIR="assets"

# Definizione struttura cartelle
DIRS=(
  "assets/images/raw/cronometro"
  "assets/images/raw/bia"
  "assets/images/raw/routine"
  "assets/images/raw/if"
  "assets/images/raw/training"

  "assets/images/processed/ep01"
  "assets/images/processed/ep02"
  "assets/images/processed/ep03"
  "assets/images/processed/ep04"
  "assets/images/processed/ep05"
  "assets/images/processed/ep06"
  "assets/images/processed/ep07"
  "assets/images/processed/ep08"

  "assets/thumbnails/ep01"
  "assets/thumbnails/ep02"
  "assets/thumbnails/ep03"
  "assets/thumbnails/ep04"
  "assets/thumbnails/ep05"
  "assets/thumbnails/ep06"
  "assets/thumbnails/ep07"
  "assets/thumbnails/ep08"

  "assets/graphics/charts"
  "assets/graphics/diagrams"
  "assets/graphics/icons"

  "assets/video/b-roll"
  "assets/video/outro"
  "assets/video/intro"
)

echo "➜ Creo la struttura directory se mancante…"
for dir in "${DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    echo "   ✓  $dir (CREATA)"
  else
    echo "   •  $dir (già esiste)"
  fi
done

echo ""
echo "➜ Aggiungo .gitkeep nelle cartelle vuote…"
find assets -type d -empty -exec sh -c '
  for d do
    if [ ! -e "$d/.gitkeep" ]; then
      touch "$d/.gitkeep"
      echo "   ✓  aggiunto $d/.gitkeep"
    else
      echo "   •  $d/.gitkeep già presente"
    fi
  done
' sh {} +

echo ""
echo "➜ Genero/aggiorno assets/INDEX.md…"

INDEX_FILE="assets/INDEX.md"

{
  echo "# VBR Assets Index"
  echo "Generato automaticamente da **asset_sync.sh**"
  echo ""
  echo "## Struttura directory"
  echo '```text'
  tree assets || find assets -print
  echo '```'
  echo ""
  echo "## Note"
  echo "- Le immagini raw vanno in **assets/images/raw/...**"
  echo "- Le immagini pronte per episodio in **assets/images/processed/epXX/**"
  echo "- Le thumbnail in **assets/thumbnails/epXX/**"
  echo "- I grafici in **assets/graphics/charts/**"
  echo "- I video (b-roll/outro/intro) in **assets/video/**"
} > "$INDEX_FILE"

echo "   ✓  INDEX.md aggiornato"

echo ""
echo "──────────────────────────────────────────────"
echo "  ✓ COMPLETATO — ora puoi fare commit & push"
echo "──────────────────────────────────────────────"
echo ""

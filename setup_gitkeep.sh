#!/bin/bash

# Aggiunge un .gitkeep in tutte le cartelle che non contengono file
# tranne eventuali altre .gitkeep già esistenti

echo "➜ Scansione directory per creare .gitkeep…"

find assets -type d -empty -exec sh -c '
  for dir do
    touch "$dir/.gitkeep"
    echo "   ✓  $dir/.gitkeep creato"
  done
' sh {} +

echo "➜ Fatto! Ora puoi: git add . && git commit -m 'add gitkeep placeholders'"

#!/bin/bash

# rename_episodes.sh - Rimuove prefissi EP0n dai nomi file in 10-Episodi/
# Uso: ./rename_episodes.sh [dry-run|exec]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EPISODES_DIR="$SCRIPT_DIR/10-Episodi"
MODE="${1:-dry-run}"  # Default: dry-run per sicurezza

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== Rinomina File Episodi ==="
echo "Directory: $EPISODES_DIR"
echo "Modalità: $MODE"
echo ""

# Controlla se directory esiste
if [[ ! -d "$EPISODES_DIR" ]]; then
    echo -e "${RED}Errore: Directory $EPISODES_DIR non trovata${NC}"
    exit 1
fi

# Trova tutti i file (non directory) con pattern EP0n- o EP0n_ o EP0n (dove n è un numero)
find "$EPISODES_DIR" -maxdepth 2 -type f | while read -r filepath; do
    filename=$(basename "$filepath")
    dirpath=$(dirname "$filepath")
    
    # Pattern: rimuove EP01-, EP02_, EP03, etc. all'inizio del nome o dopo trattino/underscore
    # Gestisce: EP01-spinaci.md, EP01_spinaci.md, video-EP01.mp4, etc.
    newname=$(echo "$filename" | sed -E 's/EP[0-9]+[-_]?//g')
    
    # Se il nome è cambiato
    if [[ "$filename" != "$newname" ]]; then
        newpath="$dirpath/$newname"
        
        # Evita sovrascritture
        if [[ -e "$newpath" ]]; then
            echo -e "${YELLOW}SKIP (esiste già): $filepath${NC}"
            continue
        fi
        
        if [[ "$MODE" == "exec" ]]; then
            mv "$filepath" "$newpath"
            echo -e "${GREEN}RENAMED: $filename → $newname${NC}"
        else
            echo -e "${YELLOW}[DRY-RUN] Rinominerò: $filename → $newname${NC}"
        fi
    fi
done

echo ""
if [[ "$MODE" == "dry-run" ]]; then
    echo -e "${YELLOW}Modalità dry-run completata. Nessun file è stato modificato.${NC}"
    echo "Per eseguire davvero le modifiche, usa: ./rename_episodes.sh exec"
else
    echo -e "${GREEN}Rinomina completata!${NC}"
fi

#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EPISODES_DIR="$SCRIPT_DIR/10-Episodi"
MODE="${1:-dry-run}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=== Rinomina Completa Episodi ==="
echo "Directory: $EPISODES_DIR"
echo "Modalità: $MODE"
echo ""

if [[ ! -d "$EPISODES_DIR" ]]; then
    echo -e "${RED}Errore: Directory $EPISODES_DIR non trovata${NC}"
    exit 1
fi

# Step 1: Rinomina file dentro le cartelle
echo -e "${BLUE}Step 1: Rinomina file interni...${NC}"
find "$EPISODES_DIR" -maxdepth 2 -type f | while read -r filepath; do
    filename=$(basename "$filepath")
    dirpath=$(dirname "$filepath")
    
    # Rimuove EP0n- o EP0n_ o EP0n dal nome
    newname=$(echo "$filename" | sed -E 's/EP[0-9]+[-_]?//g')
    
    if [[ "$filename" != "$newname" ]]; then
        newpath="$dirpath/$newname"
        
        if [[ -e "$newpath" ]]; then
            echo -e "${YELLOW}SKIP (esiste già): $filepath${NC}"
            continue
        fi
        
        if [[ "$MODE" == "exec" ]]; then
            mv "$filepath" "$newpath"
            echo -e "${GREEN}FILE: $filename → $newname${NC}"
        else
            echo -e "${YELLOW}[DRY-RUN] FILE: $filename → $newname${NC}"
        fi
    fi
done

echo ""

# Step 2: Rinomina cartelle (dal più alto numero al più basso per evitare conflitti)
echo -e "${BLUE}Step 2: Rinomina cartelle episodi...${NC}"

# Ottieni lista cartelle EPxx-slug ordinate inverso
dirs=($(ls -1 "$EPISODES_DIR" | grep -E '^EP[0-9]+-' | sort -r))

for dir in "${dirs[@]}"; do
    # Estrai slug: EP07-report -> report
    slug=$(echo "$dir" | sed -E 's/EP[0-9]+-//')
    oldpath="$EPISODES_DIR/$dir"
    newpath="$EPISODES_DIR/$slug"
    
    if [[ -d "$oldpath" ]]; then
        if [[ -e "$newpath" ]]; then
            echo -e "${YELLOW}SKIP (esiste già): $dir → $slug${NC}"
            continue
        fi
        
        if [[ "$MODE" == "exec" ]]; then
            mv "$oldpath" "$newpath"
            echo -e "${GREEN}DIR: $dir → $slug${NC}"
        else
            echo -e "${YELLOW}[DRY-RUN] DIR: $dir → $slug${NC}"
        fi
    fi
done

echo ""
if [[ "$MODE" == "dry-run" ]]; then
    echo -e "${YELLOW}Modalità dry-run completata.${NC}"
    echo "Per eseguire davvero: ./rename_all.sh exec"
else
    echo -e "${GREEN}Rinomina completata!${NC}"
    echo ""
    echo "Prossimi passi:"
    echo "1. ./episode_manager.sh set 1 colazione"
    echo "2. ./episode_manager.sh set 2 spinaci"
    echo "3. ./episode_manager.sh build-index"
fi

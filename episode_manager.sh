#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EPISODES_DIR="$SCRIPT_DIR/10-Episodi"
ORDER_FILE="$SCRIPT_DIR/.episode_order"
COMMAND="${1:-list}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

case "$COMMAND" in
    list)
        echo -e "${BLUE}=== Episodi Disponibili ===${NC}"
        ls -1 "$EPISODES_DIR" | grep -E '^[a-z]' | nl
        echo ""
        if [[ -f "$ORDER_FILE" ]]; then
            echo -e "${GREEN}=== Ordine Attuale ===${NC}"
            cat "$ORDER_FILE" | nl -w2 -s'. '
        else
            echo -e "${YELLOW}Nessun ordine definito. Usa 'set' per crearlo.${NC}"
        fi
        ;;
    
    set)
        EP_NUM="$2"
        SLUG="$3"
        
        if [[ -z "$EP_NUM" || -z "$SLUG" ]]; then
            echo "Uso: $0 set <numero_episodio> <slug>"
            exit 1
        fi
        
        if [[ ! -d "$EPISODES_DIR/$SLUG" ]]; then
            echo -e "${YELLOW}Errore: Cartella $SLUG non trovata${NC}"
            echo "Cartelle disponibili:"
            ls "$EPISODES_DIR"
            exit 1
        fi
        
        touch "$ORDER_FILE"
        sed -i "/^EP$(printf '%02d' $EP_NUM)=/d" "$ORDER_FILE"
        echo "EP$(printf '%02d' $EP_NUM)=$SLUG" >> "$ORDER_FILE"
        sort "$ORDER_FILE" -o "$ORDER_FILE"
        
        echo -e "${GREEN}Impostato: EP$(printf '%02d' $EP_NUM) → $SLUG${NC}"
        ;;
    
    build-index)
        echo -e "${BLUE}=== Rigenerazione Index_Episodi.md ===${NC}"
        
        {
            echo "# Index Episodi - Vegan Biohacking Routine"
            echo ""
            echo "| Codice | Titolo | Stato | Script | Audio | Video | Pubblicato |"
            echo "| ------:|:------ |:-----:|:------:|:-----:|:-----:|:----------:|"
            
            if [[ -f "$ORDER_FILE" ]]; then
                while IFS='=' read -r ep slug; do
                    status="🟡"
                    script="⬜"
                    audio="⬜"
                    video="⬜"
                    pub="⬜"
                    
                    EP_DIR="$EPISODES_DIR/$slug"
                    
                    [[ -f "$EP_DIR/$slug.md" ]] && script="✅"
                    [[ -d "$EP_DIR/assets" && $(ls -A "$EP_DIR/assets" 2>/dev/null) ]] && audio="✅"
                    [[ -d "$EP_DIR/footage" && $(ls -A "$EP_DIR/footage" 2>/dev/null) ]] && video="✅"
                    [[ -f "$EP_DIR/PUBLISHED" ]] && pub="✅"
                    
                    echo "| $ep | $slug | $status | $script | $audio | $video | $pub |"
                done < "$ORDER_FILE"
            fi
            
            echo ""
            echo "## Comandi"
            echo "Aggiorna ordine: ./episode_manager.sh set 1 colazione"
            echo "Rigenera index: ./episode_manager.sh build-index"
            
        } > "$EPISODES_DIR/Index_Episodi.md"
        
        echo -e "${GREEN}Index rigenerato!${NC}"
        ;;
    
    *)
        echo "Comandi: list | set <num> <slug> | build-index"
        ;;
esac

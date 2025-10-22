#!/usr/bin/env bash
# Vegan Biohacking Routine — BUILD EPISODE INDEX (v2.6 portabile)
set -euo pipefail

EP_ROOT="10-Episodi"
INDEX_FILE="${EP_ROOT}/Index_Episodi.md"

AUDIO_EXT=("wav" "mp3" "m4a" "aac" "flac" "ogg")
VIDEO_EXT=("mp4" "mov" "mkv" "webm")
PROJ_EXT=("prproj" "drp" "kdenlive" "mlt" "veg" "edl" "aup" "aup3")

yesno(){ [[ "${1:-0}" == "1" ]] && echo "✅" || echo "⬜"; }

print_header(){ cat <<'EOF'
# 🎬 Index Episodi — Vegan Biohacking Routine
### Stato avanzamento produzione (auto-aggiornato)

| Codice | Titolo (slug) | Stato | Script | Audio | Video | Montaggio | Storyboard | Checklists | Pubblicato |
|---:|:-------------------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---|
EOF
}

# --- PORTABILITY LAYER: niente -printf/-maxdepth/-mapfile/expansions ---
# Elenca le cartelle episodio come nomi "EPxx-..." ordinati per numero
episode_dirs() {
  local d name code
  for d in "$EP_ROOT"/EP*-*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    [[ "$name" =~ ^EP[0-9]{2,}- ]] || continue
    code="${name%%-*}"; code="${code#EP}"
    # ordina numericamente anche su BSD
    printf '%09d\t%s\n' "$((10#$code))" "$name"
  done | sort -n | cut -f2
}

# Primo file con una certa estensione (case-insensitive), entro 2 livelli
first_file_with_ext_depth2() {
  local base="$1" ext="$2" f sub
  shopt -s nullglob nocaseglob
  # livello 1
  for f in "$base"/*."$ext"; do
    [ -f "$f" ] && { echo "$f"; shopt -u nullglob nocaseglob; return 0; }
  done
  # livello 2
  for sub in "$base"/*/; do
    [ -d "$sub" ] || continue
    for f in "$sub"*."$ext"; do
      [ -f "$f" ] && { echo "$f"; shopt -u nullglob nocaseglob; return 0; }
    done
  done
  shopt -u nullglob nocaseglob
  return 0   # “non trovato” NON è errore
}

# Primo video export (mp4/mov/webm) che contenga final/export/master nel nome (entro 2 livelli)
first_export_video_depth2() {
  local base="$1" f sub name lower
  shopt -s nullglob nocaseglob
  # livello 1
  for f in "$base"/*.{mp4,mov,webm}; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"; lower="$(printf "%s" "$name" | tr '[:upper:]' '[:lower:]')"
    [[ "$lower" == *final* || "$lower" == *export* || "$lower" == *master* ]] && { echo "$f"; shopt -u nullglob nocaseglob; return 0; }
  done
  # livello 2
  for sub in "$base"/*/; do
    [ -d "$sub" ] || continue
    for f in "$sub"/*.{mp4,mov,webm}; do
      [ -f "$f" ] || continue
      name="$(basename "$f")"; lower="$(printf "%s" "$name" | tr '[:upper:]' '[:lower:]')"
      [[ "$lower" == *final* || "$lower" == *export* || "$lower" == *master* ]] && { echo "$f"; shopt -u nullglob nocaseglob; return 0; }
    done
  done
  shopt -u nullglob nocaseglob
  return 0
}

# --- MAIN ---
# Costruisci lista episodi (portabile)
EP_DIRS=()
while IFS= read -r __ep; do EP_DIRS+=("$__ep"); done < <(episode_dirs)

rows=()
for d in "${EP_DIRS[@]}"; do
  CODE="${d%%-*}"; SLUG="${d#*-}"; DIR="${EP_ROOT}/${d}"
  MD_FILE="${DIR}/${CODE}-${SLUG}.md"

  HAS_SCRIPT=0; [[ -f "$MD_FILE" ]] && HAS_SCRIPT=1

  # AUDIO
  HAS_AUDIO=0
  for ext in "${AUDIO_EXT[@]}"; do
    OUT="$(first_file_with_ext_depth2 "$DIR" "$ext")"
    [[ -n "${OUT:-}" ]] && { HAS_AUDIO=1; break; }
  done

  # VIDEO (grezzo)
  HAS_VIDEO=0
  for ext in "${VIDEO_EXT[@]}"; do
    OUT="$(first_file_with_ext_depth2 "$DIR" "$ext")"
    [[ -n "${OUT:-}" ]] && { HAS_VIDEO=1; break; }
  done

  # PROGETTI MONTAGGIO
  HAS_EDIT=0
  for ext in "${PROJ_EXT[@]}"; do
    OUT="$(first_file_with_ext_depth2 "$DIR" "$ext")"
    [[ -n "${OUT:-}" ]] && { HAS_EDIT=1; break; }
  done
  # oppure export finale (video con final/export/master nel nome)
  if [[ "$HAS_EDIT" -eq 0 ]]; then
    OUT="$(first_export_video_depth2 "$DIR")"
    [[ -n "${OUT:-}" ]] && HAS_EDIT=1
  fi

  # STORYBOARD (qualunque *storyboard*.md entro 2 livelli)
  HAS_STORY=0
  shopt -s nullglob nocaseglob
  for f in "$DIR"/*storyboard*.md "$DIR"/*/*storyboard*.md; do
    [ -f "$f" ] && { HAS_STORY=1; break; }
  done
  shopt -u nullglob nocaseglob

  # CHECKLISTS (tutte e tre)
  CK_REG=0; CK_EDI=0; CK_PUB=0
  shopt -s nullglob nocaseglob
  for f in "$DIR"/*checklist*_registrazione*.md "$DIR"/*/*checklist*_registrazione*.md; do CK_REG=1; break; done
  for f in "$DIR"/*checklist*_montaggio*.md "$DIR"/*/*checklist*_montaggio*.md;   do CK_EDI=1; break; done
  for f in "$DIR"/*checklist*_pubblicazione*.md "$DIR"/*/*checklist*_pubblicazione*.md; do CK_PUB=1; break; done
  shopt -u nullglob nocaseglob
  HAS_CHK=0; [[ "$CK_REG" -eq 1 && "$CK_EDI" -eq 1 && "$CK_PUB" -eq 1 ]] && HAS_CHK=1

  # PUBBLICATO (file con URL in prima riga)
  HAS_PUB=0; PUB_TXT=""
  for f in "PUBLISHED" "published.url" "published.txt"; do
    if [[ -f "${DIR}/${f}" ]]; then
      PUB_TXT="$(grep -m1 -Eo '(https?://[^ ]+)' "${DIR}/${f}" || true)"
      [[ -n "${PUB_TXT// /}" ]] && HAS_PUB=1
      break
    fi
  done

  # Stato
  if [[ "$HAS_PUB" -eq 1 ]]; then STATE="🟢"
  elif [[ "$HAS_SCRIPT" -eq 1 || "$HAS_AUDIO" -eq 1 || "$HAS_VIDEO" -eq 1 || "$HAS_EDIT" -eq 1 ]]; then STATE="🟡"
  else STATE="🔴"; fi

  ROW="| ${CODE} | ${SLUG} | ${STATE} | $(yesno $HAS_SCRIPT) | $(yesno $HAS_AUDIO) | $(yesno $HAS_VIDEO) | $(yesno $HAS_EDIT) | $(yesno $HAS_STORY) | $(yesno $HAS_CHK) | $([[ $HAS_PUB -eq 1 ]] && echo "[link](${PUB_TXT})" || echo "⬜") |"
  rows+=("$ROW")
done

{
  print_header
  printf "%s\n" "${rows[@]}"
  cat <<'EOF'

---

## Note operative
- **Script**: `EPxx-slug/EPxx-slug.md`
- **Audio/Video**: metti sorgenti in `assets/` (o nella cartella episodio).
- **Montaggio**: riconosciuto se esiste un progetto (`.prproj`, `.drp`, `.kdenlive`, `.mlt`, `.veg`, `.edl`, `.aup/.aup3`)
  **oppure** un export finale (video con "final/export/master" nel nome).
- **Pubblicato**: crea un file `PUBLISHED` con la URL YouTube nella **prima riga**.

Aggiorna l’indice:
```bash
./Build_Episode_Index.sh
EOF
} > "$INDEX_FILE"
echo "✅ Index aggiornato: ${INDEX_FILE}"


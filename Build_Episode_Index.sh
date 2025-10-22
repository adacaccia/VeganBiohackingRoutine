#!/usr/bin/env bash
# Vegan Biohacking Routine — BUILD EPISODE INDEX (v2.1)
set -euo pipefail

EP_ROOT="10-Episodi"
INDEX_FILE="${EP_ROOT}/Index_Episodi.md"

AUDIO_EXT=("wav" "mp3" "m4a" "aac" "flac" "ogg")
VIDEO_EXT=("mp4" "mov" "mkv" "webm")
PROJ_EXT=("prproj" "drp" "kdenlive" "mlt" "veg" "edl" "aup" "aup3")

yesno(){ [[ "$1" == "1" ]] && echo "✅" || echo "⬜"; }

print_header(){ cat <<'EOF'
# 🎬 Index Episodi — Vegan Biohacking Routine
### Stato avanzamento produzione (auto-aggiornato)

> Legenda: **Stato** = 🟢 pubblicato · 🟡 in sviluppo · 🔴 da impostare  
> Colonne: ✅ presente · ⬜ mancante

| Codice | Titolo (slug) | Stato | Script | Audio | Video | Montaggio | Pubblicato |
|---:|:-------------------|:---:|:---:|:---:|:---:|:---:|:---|
EOF
}

# --- PORTABILITY LAYER: GNU find vs BSD find (macOS/BusyBox) ---
# --- EXTRA PORTABLE HELPERS (depth-safe and dir listing) ---

# List episode directories as names (EPxx-...) sorted numerically by code
episode_dirs() {
  local d name code
  for d in "$EP_ROOT"/EP*-*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    # require at least 2 digits after 'EP-'
    if [[ "$name" =~ ^EP[0-9]{2,}- ]]; then
      code="${name%%-*}"
      code="${code#EP}"
      printf "%09d\t%s\n" "$((10#$code))" "$name"
    fi
  done | sort -n | cut -f2
}

# Return first matching file with extension (case-insensitive) within DIR and its immediate subdirs
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
  return 0  # <— non-failure anche se non trovato
}

# Return first video export (mp4/mov/webm) whose name contains final/export/master (case-insensitive)
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
  return 0  # <— non-failure anche se non trovato
}


if find --version >/dev/null 2>&1; then
  FIND_FLAVOR=gnu
else
  FIND_FLAVOR=bsd
fi

# Elenco file .md con timestamp (epoch) e path, separati da "|"
list_md_with_mtime() {
  local base="${1:-.}"
  if [ "$FIND_FLAVOR" = gnu ]; then
    # GNU find: ha -printf
    find "$base" -type f -name '*.md' -printf '%T@|%p\n'
  else
    # BSD/BusyBox: niente -printf → usare stat
    # macOS/BSD stat: -f '%m|%N'
    # BusyBox spesso ha 'stat -c', ma se non c'è, questo funziona su macOS
    find "$base" -type f -name '*.md' -exec stat -f '%m|%N' {} \;
  fi
}

# Solo percorso dei .md (equivalente a -printf '%p\n')
list_md_paths() {
  local base="${1:-.}"
  find "$base" -type f -name '*.md' -print
}

[[ -d "$EP_ROOT" ]] || { echo "❌ Manca directory: $EP_ROOT" >&2; exit 1; }

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
    if [[ -n "$OUT" ]]; then HAS_AUDIO=1; break; fi
  done

  # VIDEO (raw)
  HAS_VIDEO=0
  for ext in "${VIDEO_EXT[@]}"; do
    OUT="$(first_file_with_ext_depth2 "$DIR" "$ext")"
    if [[ -n "$OUT" ]]; then HAS_VIDEO=1; break; fi
  done

  # PROGETTI MONTAGGIO
  HAS_EDIT=0
  for ext in "${PROJ_EXT[@]}"; do
    OUT="$(first_file_with_ext_depth2 "$DIR" "$ext")"
    if [[ -n "$OUT" ]]; then HAS_EDIT=1; break; fi
  done
  # oppure export finale (video con final/export/master nel nome)
  if [[ "$HAS_EDIT" -eq 0 ]]; then
    OUT="$(find "$DIR" -maxdepth 2 -type f \
      \( -iregex '.*\.\(mp4\|mov\|webm\)$' -a \( -iname '*final*' -o -iname '*export*' -o -iname '*master*' \) \) \
      -print -quit)"
    [[ -n "$OUT" ]] && HAS_EDIT=1
  fi

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

  ROW="| ${CODE} | ${SLUG} | ${STATE} | $(yesno $HAS_SCRIPT) | $(yesno $HAS_AUDIO) | $(yesno $HAS_VIDEO) | $(yesno $HAS_EDIT) | $([[ $HAS_PUB -eq 1 ]] && echo "[link](${PUB_TXT})" || echo "⬜") |"
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

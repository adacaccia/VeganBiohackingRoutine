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

[[ -d "$EP_ROOT" ]] || { echo "❌ Manca directory: $EP_ROOT" >&2; exit 1; }

mapfile -t EP_DIRS < <(find "$EP_ROOT" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | grep -E '^EP[0-9]{2,}-' | sort -V)

rows=()
for d in "${EP_DIRS[@]}"; do
  CODE="${d%%-*}"; SLUG="${d#*-}"; DIR="${EP_ROOT}/${d}"
  MD_FILE="${DIR}/${CODE}-${SLUG}.md"
  HAS_SCRIPT=0; [[ -f "$MD_FILE" ]] && HAS_SCRIPT=1

  # AUDIO
  HAS_AUDIO=0
  for ext in "${AUDIO_EXT[@]}"; do
    OUT="$(find "$DIR" -maxdepth 2 -type f -iname "*.${ext}" -print -quit)"
    if [[ -n "$OUT" ]]; then HAS_AUDIO=1; break; fi
  done

  # VIDEO (raw)
  HAS_VIDEO=0
  for ext in "${VIDEO_EXT[@]}"; do
    OUT="$(find "$DIR" -maxdepth 2 -type f -iname "*.${ext}" -print -quit)"
    if [[ -n "$OUT" ]]; then HAS_VIDEO=1; break; fi
  done

  # PROGETTI MONTAGGIO
  HAS_EDIT=0
  for ext in "${PROJ_EXT[@]}"; do
    OUT="$(find "$DIR" -maxdepth 2 -type f -iname "*.${ext}" -print -quit)"
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

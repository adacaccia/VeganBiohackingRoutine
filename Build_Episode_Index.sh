#!/usr/bin/env bash
# ============================================================
# Vegan Biohacking Routine — BUILD EPISODE INDEX (v2.0)
# Genera 10-Episodi/Index_Episodi.md auto-compilando:
# - Stato complessivo + colonne Script/Audio/Video/Montaggio/Pubblicato
# - Nessun ORDER.csv, sort per numero episodio (EPxx) crescente
# Rilevazioni:
#   Script:   esiste EPxx-*.md nella cartella episodio
#   Audio:    file audio in assets/ o dir episodio  (wav, mp3, m4a, aac, flac, ogg)
#   Video:    file video raw in assets/ o dir       (mp4, mov, mkv, webm)
#   Montaggio:progetti in notes/ o dir              (prproj, drp, kdenlive, mlt, veg, edl)
#              oppure export finale in assets/      (mp4/mov con 'final'/'export' nel nome)
#   Pubblicato: file PUBLISHED (con URL) oppure published.url|published.txt
# Stato: 🟢 pubblicato · 🟡 in sviluppo (ha almeno Script o asset) · 🔴 da impostare
# ============================================================

set -euo pipefail

EP_ROOT="10-Episodi"
INDEX_FILE="${EP_ROOT}/Index_Episodi.md"

AUDIO_EXT=("wav" "mp3" "m4a" "aac" "flac" "ogg")
VIDEO_EXT=("mp4" "mov" "mkv" "webm")
PROJ_EXT=("prproj" "drp" "kdenlive" "mlt" "veg" "edl" "aup" "aup3")
# criteri "montaggio concluso": export finale
EXPORT_HINT=("final" "export" "master")

# --- helper: icona si/no ---
yesno() { [[ "$1" == "1" ]] && echo "✅" || echo "⬜"; }

# --- header MD ---
print_header() {
cat <<'EOF'
# 🎬 Index Episodi — Vegan Biohacking Routine
### Stato avanzamento produzione (auto-aggiornato)

> Legenda: **Stato** = 🟢 pubblicato · 🟡 in sviluppo · 🔴 da impostare  
> Colonne: ✅ presente · ⬜ mancante

| Codice | Titolo (slug) | Stato | Script | Audio | Video | Montaggio | Pubblicato |
|---:|:-------------------|:---:|:---:|:---:|:---:|:---:|:---|
EOF
}

# --- verifica root episodi ---
[[ -d "$EP_ROOT" ]] || { echo "❌ Manca directory: $EP_ROOT" >&2; exit 1; }

# --- elenca cartelle episodio EPxx-slug e ordina per numero ---
mapfile -t EP_DIRS < <(find "$EP_ROOT" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | grep -E '^EP[0-9]{2,}-' | sort -V)

rows=()

for d in "${EP_DIRS[@]}"; do
  CODE="${d%%-*}"           # EPxx
  SLUG="${d#*-}"            # slug
  DIR="${EP_ROOT}/${d}"

  # file principale atteso
  MD_FILE="${DIR}/${CODE}-${SLUG}.md"
  HAS_SCRIPT=0
  [[ -f "$MD_FILE" ]] && HAS_SCRIPT=1

  # trova audio
  HAS_AUDIO=0
  for ext in "${AUDIO_EXT[@]}"; do
    if find "$DIR" -maxdepth 2 -type f -iregex ".*\.${ext}$" -print -quit >/dev/null; then
      HAS_AUDIO=1; break
    fi
  done

  # trova video (raw)
  HAS_VIDEO=0
  for ext in "${VIDEO_EXT[@]}"; do
    if find "$DIR" -maxdepth 2 -type f -iregex ".*\.${ext}$" -print -quit >/dev/null; then
      HAS_VIDEO=1; break
    fi
  done

  # trova progetti montaggio o export finale
  HAS_EDIT=0
  for ext in "${PROJ_EXT[@]}"; do
    if find "$DIR" -maxdepth 2 -type f -iregex ".*\.${ext}$" -print -quit >/dev/null; then
      HAS_EDIT=1; break
    fi
  done
  if [[ "$HAS_EDIT" -eq 0 ]]; then
    # cerca export finale (video con "final/export/master" nel nome)
    if find "$DIR" -maxdepth 2 -type f -iregex '.*\.\(mp4\|mov\|webm\)$' -iname '*final*' -o -iname '*export*' -o -iname '*master*' -print -quit >/dev/null 2>&1; then
      HAS_EDIT=1
    fi
  fi

  # pubblicazione: file PUBLISHED* con URL
  PUB_TXT=""
  PUB_FILE=""
  for f in "PUBLISHED" "published.url" "published.txt"; do
    if [[ -f "${DIR}/${f}" ]]; then PUB_FILE="${DIR}/${f}"; break; fi
  done
  HAS_PUB=0
  if [[ -n "$PUB_FILE" ]]; then
    # prima riga non vuota = link
    PUB_TXT="$(grep -m1 -Eo '(https?://[^ ]+)' "$PUB_FILE" || true)"
    [[ -n "${PUB_TXT// /}" ]] && HAS_PUB=1
  fi

  # stato complessivo
  if [[ "$HAS_PUB" -eq 1 ]]; then
    STATE="🟢"
  elif [[ "$HAS_SCRIPT" -eq 1 || "$HAS_AUDIO" -eq 1 || "$HAS_VIDEO" -eq 1 || "$HAS_EDIT" -eq 1 ]]; then
    STATE="🟡"
  else
    STATE="🔴"
  fi

  # colonne
  C_SCRIPT="$(yesno $HAS_SCRIPT)"
  C_AUDIO="$(yesno $HAS_AUDIO)"
  C_VIDEO="$(yesno $HAS_VIDEO)"
  C_EDIT="$(yesno $HAS_EDIT)"
  if [[ "$HAS_PUB" -eq 1 ]]; then
    C_PUB="[link](${PUB_TXT})"
  else
    C_PUB="⬜"
  fi

  ROW="| ${CODE} | ${SLUG} | ${STATE} | ${C_SCRIPT} | ${C_AUDIO} | ${C_VIDEO} | ${C_EDIT} | ${C_PUB} |"
  rows+=("$ROW")
done

# --- scrivi file index ---
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
- **Pubblicato**: crea un file `PUBLISHED` (o `published.url`/`published.txt`) con la URL YouTube nella **prima riga**.

Esempio:

10-Episodi/EP03-spinaci/
├── EP03-spinaci.md
├── assets/
│ ├── broll_spinaci_01.mp4
│ └── voce_ep03_final.mp3
├── notes/
│ └── timeline.kdenlive
└── PUBLISHED # contiene: https://youtu.be/xxxxxxxxxxxù


Aggiorna l’indice con:
```bash
./Build_Episode_Index.sh
EOF
} > "$INDEX_FILE"

echo "✅ Index aggiornato: ${INDEX_FILE}"

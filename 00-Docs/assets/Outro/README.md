# 🎬 Outro Kit — Vegan Biohacking Routine

### Libreria grafica e audio per Outro Universale

---

## 📁 Struttura

00-Docs/
└── assets/
└── Outro/
├── VBR_Outro_Template.kdenlive
├── voice_outro.wav
├── music_outro.mp3
├── VBR_EndScreen_1080p.mp4
└── README.md ← questo file

---

## 🎧 Contenuti

| File                            | Descrizione                                                                            | Durata | Note                                          |
| ------------------------------- | -------------------------------------------------------------------------------------- | ------ | --------------------------------------------- |
| **VBR_Outro_Template.kdenlive** | progetto base Kdenlive (8 s) con tracce voce, musica, testo e background già allineate | 8 s    | da clonare per ogni episodio                  |
| **voice_outro.wav**             | placeholder audio voce (sintetico)                                                     | 8 s    | sostituire con la voce reale                  |
| **music_outro.mp3**             | base musicale placeholder                                                              | 8 s    | sostituire con musica effettiva               |
| **VBR_EndScreen_1080p.mp4**     | sfondo video statico (bianco caldo + testo)                                            | 8 s    | sostituire con clip reale o immagine coerente |

---

## 🧩 Uso pratico

1. **Apri** `VBR_Outro_Template.kdenlive`  
2. **Sostituisci**:
   - `voice_outro.wav` → voce reale dell’episodio  
   - `music_outro.mp3` → base musicale effettiva  
   - `VBR_EndScreen_1080p.mp4` → sfondo finale o immagine del giorno  
3. **Esporta** come `VBR_Outro_EPxx.mp4` e spostalo in:  
   `10-Episodi/EPxx-.../assets/`

---

## 🧠 Note tecniche

- Risoluzione: **1920×1080 (16:9)**  
- Frame rate: **25 fps**  
- Lunghezza: **8 s esatti**  
- Volume target:
  - voce –2 dB  
  - musica –8 dB  
  - background –12 dB  

---

## 🛠️ Generazione placeholder (opzionale)

Se devi rigenerare i file placeholder:

```bash
# crea audio sintetico voce
sox -n -r 44100 -c 1 voice_outro.wav synth 8 sin 440 vol 0.02 fade t 0.1 8 0.5

# crea audio base musicale
sox -n -r 44100 -c 2 music_outro.mp3 synth 8 sin 220 vol 0.01 fade t 0.5 8 1

# crea video sfondo
ffmpeg -f lavfi -i color=c=#f6f3e9:s=1920x1080:d=8 \
       -vf "drawtext=text='Vegan Biohacking Routine — Outro Test':fontcolor=#333333:fontsize=48:x=(w-text_w)/2:y=(h-text_h)/2" \
       -c:v libx264 -pix_fmt yuv420p VBR_EndScreen_1080p.mp4
(richiede i pacchetti sox e ffmpeg)

“L’Outro non è un addio: è la continuità del ritmo.”
— Vegan Biohacking Routine, 2025
```

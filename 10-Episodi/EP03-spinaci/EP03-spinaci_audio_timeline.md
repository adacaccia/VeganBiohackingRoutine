# 🎧 Audio Timeline — EP03 · Spinaci e densità nutritiva  
### Vegan Biohacking Routine · Voice, Crunch & Music Sync Map

---

## 🧩 Struttura generale

| Segmento | Inizio (ms) | Fine (ms) | Durata | Tracce attive | Note |
|-----------|--------------|------------|---------|----------------|------|
| **Intro voce** | 0 | 90,000 | 1′30″ | A1 (voce) + A2 (musica) | Volume voce 0 dB, musica −8 dB |
| **Densità nutritiva** | 90,000 | 150,000 | 1′00″ | A1 + A2 | Leggera pausa a 1:20 per enfasi “zero grassi inutili” |
| **Crunch come chips** | 150,000 | 180,000 | 0′30″ | A1 + A2 + A3 (Foley) | Sincronizzazione “crunch” precisa (vedi sotto) |
| **Spiegazione scientifica** | 180,000 | 210,000 | 0′30″ | A1 + A2 | Leggera EQ brillante sulla voce (+2 dB @ 5 kHz) |
| **Cronometer demo (L+Z)** | 210,000 | 255,000 | 0′45″ | A1 + A3 (click) | Musica muta tra 225,000–235,000 ms (crollo barre) |
| **Shrinkflation** | 255,000 | 285,000 | 0′30″ | A1 + A2 | Sorriso vocale su “spallucce” (+1 dB voce) |
| **Sintesi e riflessione** | 285,000 | 315,000 | 0′30″ | A1 + A2 | Dissolvenza musicale in 2 s (313,000–315,000) |
| **Outro** | 315,000 | 330,000 | 0′15″ | A1 + A2 | Outro universale · fade out 1.5 s |

Totale durata: **≈ 330,000 ms (5′30″)**  

---

## 🥬 Sezione “Crunch come chips” — Dettaglio frame

| Evento | Timestamp (ms) | Traccia | Azione / Livello | Note |
|---------|----------------|----------|------------------|------|
| Apertura busta | 151,200 | A3 | −10 dB | Rumore secco, taglio basso 150 Hz |
| Primo “crunch” | 152,500 | A3 | −8 dB | Pan leggero L (−10%) |
| Secondo “crunch” | 155,300 | A3 | −8 dB | Pan leggero R (+10%) |
| Frase “fa lo stesso rumore…” | 156,000 | A1 | 0 dB | Pausa 0.3 s prima del primo crunch |
| Silenzio musicale | 151,000–157,000 | A2 | Mute | Lascia i suoni protagonisti |
| Ritorno musica | 157,000 | A2 | −8 dB | Fade in 500 ms |

🎧 *Nota:* mantieni una piccola “aria” (300 ms) tra il secondo crunch e la ripresa della voce.

---

## 💻 Sezione Cronometer — Dettaglio audio/visivo

| Evento | Timestamp (ms) | Traccia | Volume | Descrizione |
|---------|----------------|----------|----------|-------------|
| Click rimozione spinaci | 215,000 | A3 | −12 dB | Inizio discesa barre |
| Silenzio voce + musica | 225,000–235,000 | A1/A2 | mute | Pause visiva (crollo a 0) |
| Click reinserimento | 238,000 | A3 | −12 dB | Barre tornano verdi |
| Ripresa voce | 240,000 | A1 | 0 dB | “...vedete il buco che si crea…” |
| Ripresa musica | 241,000 | A2 | −8 dB | Fade in 1 s |

🎛️ EQ voce durante demo:  
–1.5 dB @ 3 kHz (per lasciare spazio ai click), +2 dB @ 6 kHz (chiarezza).

---

## 🎵 Transizioni musicali chiave

| Punto | Tipo | Durata | Note |
|--------|------|---------|------|
| 0:00 → 0:03 | Fade-in | 3 s | Ingresso naturale |
| 2:30 → 2:33 | Fade-out | 0.5 s | prima del “crunch” |
| 2:37 → 2:40 | Fade-in | 0.5 s | dopo il “crunch” |
| 3:30 → 3:35 | Fade-out | 1 s | ingresso Cronometer |
| 3:55 → 4:00 | Fade-in | 1 s | dopo reinserimento spinaci |
| 5:13 → 5:30 | Fade-out finale | 1.5 s | Outro universale |

---

## 🔊 Verifica finale (test checklist)

- [ ] Sincronizzazione perfetta tra gesto e “crunch” (errore < 50 ms)  
- [ ] Click Cronometer percepibile ma non invadente  
- [ ] Voce mai mascherata nei 5–6 kHz  
- [ ] Transizioni musica fluide (nessun salto di loudness)  
- [ ] Outro universale presente e normalizzata (−14 LUFS)  
- [ ] Esportazione WAV mix master in `assets/final/`

---

🎧 **Output finale raccomandato:**  
- File master: `EP03_spinaci_mix_master.wav`  
- Codec video finale: H.264 @ 18 Mb/s  
- Audio container: AAC 192 kbps / 48 kHz stereo  

---

© 2025 Vegan Biohacking Routine — EP03 Audio Timeline  
Licenza CC-BY-NC 4.0

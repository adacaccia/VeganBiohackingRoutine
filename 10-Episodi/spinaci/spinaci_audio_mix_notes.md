# 🎚️ Audio Mix Notes — EP03 · Spinaci e densità nutritiva  
### Vegan Biohacking Routine · Mix & Mastering reference

---

## 🎧 Obiettivo sonoro generale
Tono **naturale, intimo e realistico**, con dinamica controllata.  
La voce deve restare in primo piano, con i suoni reali (busta, “crunch”, click) ben percepibili ma mai invasivi.

Target finale:  
- **Loudness integrato:** −14 LUFS  
- **True Peak:** −1.0 dBTP  
- **Gamma dinamica:** 10–12 LU  

---

## 🎙️ Voce principale
| Step | Parametro | Valore / Preset |
|------|------------|-----------------|
| EQ | HPF 80 Hz / +2 dB @ 5 kHz / –1.5 dB @ 300 Hz | Schiarire, togli nasale |
| De-esser | 6.5 kHz, soglia –18 dB | Attenuare “s” |
| Comp | Ratio 3:1 / Attack 15 ms / Release 90 ms / Gain +2 dB | Livello costante |
| Reverb | Room corta (0.4 s, dry 80 %) | Leggera presenza |
| Normalizzazione | −14 LUFS | Standard VBR |

🎧 *Note:* nelle frasi “crunch come chips” e “spallucce” abbassa la compressione (ratio 2.5:1) per preservare naturalezza.

---

## 🥬 Suoni ambiente / Foley
| File | Scopo | Trattamento |
|------|--------|--------------|
| `busta_opening.wav` | apertura busta | HPF 150 Hz / LPF 12 kHz / −10 dB |
| `crunch_raw_takeX.wav` | masticazione “crunch” | HPF 150 Hz / +3 dB @ 4.5 kHz / –8 dB globale |
| `click_mouse.wav` | navigazione Cronometer | centrato stereo / −12 dB |
| Amb. cucina | presenza leggera (–20 dB) | fade in/out 0.5 s |

🎛️ *Mix tip:* Pan leggero L–R alternato tra crunch e voce (5–10 %) per creare spazialità naturale.

---

## 🎵 Musica
- Brano: *Soft Pad Ambient (A-minor, 70 BPM)*  
- EQ: LPF 12 kHz / –6 dB @ 200 Hz  
- Volume medio: −8 dB (voce sopra di +6 dB)  
- Fade in: 1.0 s · Fade out: 1.5 s  
- Cut automatico di 2 s durante “crunch” e “Cronometer demo”  
- Ripresa musica in dissolvenza subito dopo.

---

## 💻 Cronometer Demo (screen capture audio)
- Volume click: −12 dB  
- EQ: HPF 200 Hz / boost +2 dB @ 3 kHz  
- Sezione voce: leggero notch –1.5 dB @ 3 kHz per evitare mascheramento  
- Pausa silenziosa (musica muta) nei 2 s centrali di “crollo barre”  

---

## 🔊 Master chain finale (ordine)
1. EQ correttivo voce  
2. Compressor  
3. De-esser  
4. Ambience bus (Foley + Music)  
5. Master limiter → Ceiling −1.0 dBTP  
6. Loudness meter → target −14 LUFS  

---

## 🎨 Bilanciamento finale (mix bus)

| Elemento | Livello relativo | Note |
|-----------|------------------|------|
| Voce | 0 dB | riferimento principale |
| Musica | −8 dB | pad costante, sfondo morbido |
| Crunch / Foley | −10 → −8 dB | percepibile, non dominante |
| Click / ambiente | −12 → −14 dB | riempitivo naturale |

---

## 🧠 Extra suggerimenti
- Usa **limiter con soft knee** per evitare clipping nel “crunch”.  
- Evita compressione parallela: mantiene dinamica “umana”.  
- Ascolta il mix finale sia con cuffie chiuse che con speaker desktop → equilibrio voce/ambiente.  
- Salva anche una versione *voice only* (`EP03_spinaci_voice_mix.wav`) per eventuali adattamenti linguistici futuri (es. doppiaggio EN).

---

🎬 **File finale:**  
`EP03_spinaci_mix_master.wav`  
→ import diretto in Kdenlive A1 (sostituisce traccia voce + foley consolidata)

---

© 2025 Vegan Biohacking Routine — Audio mix notes  
Licenza CC-BY-NC 4.0

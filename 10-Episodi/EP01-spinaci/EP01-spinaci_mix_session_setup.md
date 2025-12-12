# 🎛️ Mix Session Setup — EP03 · Spinaci e densità nutritiva  
### Vegan Biohacking Routine · Kdenlive Project Configuration

---

## 🎬 Progetto base

| Parametro | Valore |
|------------|---------|
| Nome file progetto | `EP03_spinaci.kdenlive` |
| Directory | `10-Episodi/EP03-spinaci/` |
| Formato video | 1920×1080 (Full HD) |
| Frame rate | 25 fps |
| Audio rate | 48 kHz / 24-bit |
| Durata target | 5′30″ |
| Codifica finale | H.264 (CRF 18) / AAC 192 kbps |
| Aspect ratio | 16:9 |
| Color space | Rec.709 |

---

## 🎧 Tracce consigliate

| Traccia | Tipo | Contenuto | Volume base | Note |
|----------|------|------------|--------------|------|
| **V1** | Video | A-roll principale (Adalberto, close-up, Cronometer) | — | Tutte le clip principali |
| **V2** | Video | Overlay testo, grafici, titoli | — | Dissolvenze 1 s |
| **A1** | Audio | Voce narrante (mix master) | 0 dB | file `EP03_spinaci_mix_master.wav` |
| **A2** | Audio | Musica ambientale (pad) | −8 dB | file `EP03_music_pad.wav` |
| **A3** | Audio | Foley (crunch, busta, click) | −10 dB | mix foley consolidato |
| **A4** | Audio | Backup voce / FX room | mute | per versioni alternative |

---

## 🎚️ Effetti e plugin (Kdenlive > Effetti audio)

| Plugin | Parametri | Applicato a | Note |
|---------|------------|--------------|------|
| EQ parametrico | HPF 80 Hz / +2 dB @ 5 kHz / −1.5 dB @ 300 Hz | Voce (A1) | Preset “VBR-voice” |
| Compressor | Ratio 3:1 / Attack 15 ms / Release 90 ms | Voce (A1) | Gain makeup +2 dB |
| De-esser | Freq. 6.5 kHz / soglia −18 dB | Voce (A1) | Leggera attenuazione “s” |
| Reverb (room) | Mix 15 %, decay 0.4 s | Voce (A1) | Aggiunge naturalezza |
| Limiter | Ceiling −1.0 dBTP | Master Bus | Output sicuro |
| EQ Foley | HPF 150 Hz / +3 dB @ 4.5 kHz | Foley (A3) | Esalta “crunch” |
| Volume automation | keyframe – mute 2:30–2:40 | Musica (A2) | per silenzio durante “crunch” |
| Fade auto | 0.8 s entrata / 1.5 s uscita | Tutte le clip | Fluidità transizioni |

---

## 🎨 Titoli e overlay testuali

| Scena | Testo | Colore | Font | Durata |
|--------|-------|--------|------|---------|
| Intro | “Spinaci e densità nutritiva” | #4a6d41 | Inter Bold 32 pt | 4 s |
| Scientifico | “Crudi = massima densità / minima dispersione” | #8ccf79 | Inter Regular 28 pt | 6 s |
| Cronometer | “Luteina + Zeaxantina ↓ senza spinaci” | #cc4c39 | Inter Regular 26 pt | 5 s |
| Shrinkflation | “400 g = 100 % Nutrition Target ✅” | #8ccf79 | Inter Bold 30 pt | 4 s |
| Citazione finale | “La semplicità non è povertà: è controllo.” | #333333 | Montserrat Italic 28 pt | 5 s |

---

## 🧠 Automazioni chiave

- **Musica mute (A2)**  
  - Da 150,000 ms a 157,000 ms → sezione “crunch come chips”.  
  - Da 225,000 ms a 235,000 ms → crollo barre Cronometer.  
  - Fade-in successivo 1 s.  

- **Voce boost (A1)**  
  +1 dB in “spallucce” (ms 275,000–280,000).

- **Pan Foley (A3)**  
  Crunch 1: L (−10 %), Crunch 2: R (+10 %).

- **Master automation**  
  Fade-out finale 1.5 s (313,000–330,000 ms).

---

## 🧩 Marker suggeriti (timeline)
| Marker | Timestamp | Descrizione |
|---------|------------|-------------|
| M1 | 0:00 | Inizio Intro |
| M2 | 1:30 | Inizio Densità nutritiva |
| M3 | 2:30 | Crunch come chips |
| M4 | 3:00 | Sezione scientifica |
| M5 | 3:30 | Cronometer demo |
| M6 | 4:15 | Shrinkflation |
| M7 | 4:45 | Sintesi |
| M8 | 5:15 | Outro |

---

## 📦 Esportazione finale

| Parametro | Valore |
|------------|---------|
| Profilo Kdenlive | H.264 / High Profile |
| Bitrate | 18 Mb/s costante |
| Audio codec | AAC 192 kbps, stereo |
| Loudness target | −14 LUFS |
| Output file | `EP03_spinaci_final.mp4` |
| Verifica visiva | Overlay leggibili, sincronizzazione perfetta “crunch–gesto” |
| Backup | `archives/2025-EP03/` |

---

## ✅ Check di chiusura sessione
- [ ] Waveform A3 allineata ai picchi visivi mano-busta  
- [ ] Nessuna saturazione in A1 / Master  
- [ ] Overlay Cronometer leggibili su mobile  
- [ ] Outro completa (logo + 8 s)  
- [ ] Salvataggio copia `.kdenlive.bak`  
- [ ] Sincronizzazione in repository Git completata  

---

© 2025 Vegan Biohacking Routine — EP03 Spinaci e densità nutritiva  
Licenza CC-BY-NC 4.0

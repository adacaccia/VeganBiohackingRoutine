# 🎧 PROFILO AUDIO “VBR_VoiceClean” – OBS + Kdenlive (Linux / Manjaro)

## 🎙️ 1️⃣ PROFILO OBS STUDIO
Crea un nuovo profilo e una scena con microfono pulito.

### 🎛️ Filtri consigliati (ordine)
1. **Compressor**
   - Ratio: 2.5:1  
   - Threshold: –18 dB  
   - Attack: 10 ms  
   - Release: 120 ms  
   - Output Gain: +2 dB

2. **Noise Gate**
   - Close Threshold: –42 dB  
   - Open Threshold: –36 dB  
   - Attack/Release: default

3. **Limiter**
   - Threshold: –1 dB  
   - Release: 60 ms

🎯 *Registra con picchi intorno a –12 dB (barra gialla, mai rossa).*

---

## 🎬 2️⃣ PROFILO KDENLIVE – “Mix LUFS –14”
Crea un progetto:
- Video: 1080p / 30 fps  
- Audio: 48 000 Hz stereo  
- Rendering: MP4 (H.264 + AAC 192 kbps)

### 🔹 Effetti sulla traccia voce
1. **Equalizer**
   - Taglia sotto 80 Hz  
   - +2 dB a 3 kHz (chiarezza)  

2. **Compressore**
   - Ratio: 2:1  
   - Threshold: –20 dB  
   - Attack: 15 ms  
   - Release: 200 ms  
   - Output Gain: +2 dB  

3. **Normalizzatore**
   - Target: –14 dB RMS  
   *(equivalente a –14 LUFS)*

🎯 *Mix bilanciato per YouTube, voce dominante e naturale.*

---

## 🎧 3️⃣ PLUGIN OPZIONALI (se vuoi misurare i LUFS)
Installa da terminale:

```bash
sudo pacman -S calf lsp-plugins
```
Quando chiede:
```
:: Ci sono 2 fornitori disponibili per clap-host
1) qtractor  2) reaper
```
→ Digita **1** (qtractor).

Poi riavvia Kdenlive:
- Attiva `Calf Loudness Meter` o `LSP Loudness Meter Stereo`  
  per leggere LUFS integrato e True Peak.

---

## 🎯 OBIETTIVI FINALI
| Fase | Target | Note |
|------|---------|------|
| Registrazione (OBS) | Picchi –12 dBFS | segnale pulito, dinamica viva |
| Montaggio (Kdenlive) | Mix medio –14 LUFS / –14 dB RMS | equilibrio voce–musica |
| Export | –1 dBTP max | MP4 H.264 48 kHz stereo |

---

© 2025 Vegan Biohacking Routine — Profilo “VBR_VoiceClean”  
Licenza CC-BY-NC 4.0

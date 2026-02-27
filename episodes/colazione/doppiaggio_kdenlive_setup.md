# 🎙️ Workflow Doppiaggio in Post – Kdenlive  
### Vegan Biohacking Routine · Guida base per creator modulari

---

## 🎬 1️⃣ Durante la ripresa
- 🎥 Registra **video muto** (niente parlato): muoviti lentamente e lascia **pause visive** dove inserirai la voce.  
- 🤫 Se serve, **sussurra leggermente** le frasi per avere un riferimento labiale.  
- 🕒 Lascia 2–3 secondi di margine prima e dopo ogni gesto chiave.  
- 🔇 Evita qualsiasi rumore ambientale (frigo, passi, stoviglie, vento).  
- 🗒️ Tieni un foglio con **battute e tempi stimati** a vista per mantenere ritmo e coerenza.  

---

## 🎧 2️⃣ Preparazione del progetto in Kdenlive
1. Crea un nuovo progetto `EP02_colazione.kdenlive` (1080p · 25 fps).  
2. Importa il video muto e blocca la traccia audio originale (click destro → “Blocca traccia audio”).  
3. Aggiungi una **nuova traccia audio** (A2 → *Doppiaggio*).  
4. Apri il **Mixer audio** (`Ctrl + M`) per monitorare livelli in tempo reale.  

---

## 🎙️ 3️⃣ Registrazione voce in Kdenlive
1. Seleziona la traccia A2.  
2. Vai su **Effetti → Audio → Registra voce su traccia**.  
3. Premi “Rec” e parla con tono naturale, seguendo i gesti nel video.  
4. Usa un **microfono esterno o cuffie cablate**, distanza 20–25 cm.  
5. Registra in ambiente silenzioso, tendine chiuse, 48 kHz / 24 bit.  

---

## 🎚️ 4️⃣ Post-produzione audio
- **EQ base:**  
  - HPF 80 Hz (taglia i bassi ambientali).  
  - +2 dB @ 5 kHz (chiarezza voce).  
  - −1.5 dB @ 300 Hz (rimuove nasale).  
- **Compressore:** ratio 2.5:1 / attack 20 ms / release 100 ms.  
- **Normalizza:** target −14 LUFS.  
- **Limiter:** ceiling −1.0 dBTP.  
- **Noise Reduction (se serve):** effetto “Sottrazione rumore” con profilo da 10 s silenzio iniziale.  

---

## 🗂️ 5️⃣ Esportazione e archiviazione
- Esporta voce in **WAV 48 kHz / 24 bit** → `voice_EP02_colazione.wav`.  
- Salva una copia anche in `assets/voice-only/` per doppiaggi futuri (es. versione EN).  
- Mantieni la struttura del progetto:  
  ```text
  EP02/
  ├── video/
  ├── audio/
  │   ├── voice_EP02_colazione.wav
  │   └── mix_master.wav
  └── kdenlive/
  ```

---

## 💡 Suggerimenti pratici
- 🎧 Ascolta sempre il mix finale con **cuffie e altoparlanti**: se la voce è chiara in entrambi, sei a posto.  
- 🕹️ Se vuoi dare più “presenza” alla voce, aggiungi un leggero **riverbero Room corta (0.3 s)**.  
- 🗣️ Evita di leggere: pensa di “raccontare” la scena come fosse un diario.  
- ⏱️ In caso di desincronizzazione labiale, usa *Velocità clip 98–102 %* per piccoli aggiustamenti.

---

© 2025 *Vegan Biohacking Routine – Workflow doppiaggio in post*  
Licenza CC-BY-NC 4.0  

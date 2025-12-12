# 🎧 Mini-Setup Kdenlive – Sezione ASMR (“Crunch come chips”)
### Vegan Biohacking Routine · EP03 – Spinaci e densità nutritiva

---

## 🎞️ Tracce consigliate

| Traccia | Tipo | Contenuto | Note |
|----------|------|------------|------|
| **A1 – Voce** | Audio | Narrazione principale | Volume −2 dB |
| **A2 – Musica** | Audio | Pad ambientale | Volume −8 dB, *mute* durante ASMR |
| **A3 – Foley1** | Audio | Busta che si apre, suoni di contatto | EQ taglio bassi, stereo L–R leggero |
| **A4 – Foley2 (ASMR)** | Audio | “Crunch” e masticazione | EQ brillante, compressione leggera, centrale |

---

## 🎚️ Livelli consigliati
- **Voce:** 0 dB riferimento generale (ASMR: disattiva temporaneamente)  
- **Foley1 (busta):** −10 dB  
- **Foley2 (crunch):** −8 dB (puoi salire a −6 dB se vuoi più presenza)  
- **Musica:** −8 dB (fade-out completo 1 s prima del primo crunch, fade-in 1 s dopo l’ultimo)  
- **Peak meter finale:** nessun picco oltre −1 dB  

---

## 🎛️ Filtri da applicare

### Foley1 (busta)
- **Equalizzatore semplice → Taglia sotto 150 Hz**  
- **Riduzione rumore (se serve)**  
- **Panning L/R:** leggero (L −10 %, R +10 %) per spazialità naturale  

### Foley2 (crunch)
- **Equalizzatore avanzato:**  
  - +3 dB @ 4.5 kHz  
  - −2 dB @ 300 Hz  
- **Compressore audio:**  
  - Ratio 2.5:1  
  - Attack 20 ms  
  - Release 100 ms  
- **Normalizza:** −14 LUFS  
- *Opzionale:* **Riverbero Room corta (0.3 s)** per un minimo di aria  

---

## 🕓 Timeline – Sezione ASMR
```
│0:00────────────2:55────────────3:25────────────>
│   (voce+musica)   (solo Foley1+Foley2)   (rientro voce+musica)
```
- A2 (musica): Mute da 2:55 → 3:25  
- A3 (busta): entra 0.5 s prima del primo crunch, fade-out 1 s dopo  
- A4 (crunch): 2–3 eventi, distanza 2 s, alternanza L/R  
- A1 (voce): pausa completa (taglio o mute)  

---

## 🧠 Trucco pratico
Duplica la clip *crunch.wav* su A4, spostala di 2–3 frame e abbassa di 6 dB: otterrai un effetto di “corpo” realistico, simile a un microfono binaurale.

---

© 2025 Vegan Biohacking Routine — EP03 Spinaci  
Licenza CC-BY-NC 4.0

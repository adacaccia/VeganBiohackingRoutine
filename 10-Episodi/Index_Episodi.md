# 🎬 Index Episodi — Vegan Biohacking Routine
### Stato avanzamento produzione (auto-aggiornato)

> Legenda: **Stato** = 🟢 pubblicato · 🟡 in sviluppo · 🔴 da impostare  
> Colonne: ✅ presente · ⬜ mancante

| Codice | Titolo (slug) | Stato | Script | Audio | Video | Montaggio | Pubblicato |
|---:|:-------------------|:---:|:---:|:---:|:---:|:---:|:---|
| EP01 | la-colazione-consapevole | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP02 | il-trito-funzionale | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP03 | spinaci-e-densita-nutritiva | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP04 | passata-di-pomodoro-il-carburante-lento | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP05 | legumi-il-motore-silenzioso | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP06 | vegan-fisiologia-non-ideologia | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP07 | caffe-e-lucidita-controllata | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP08 | denti-e-performance | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP09 | germogli-vita-in-miniatura | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP10 | fitness-e-coerenza-metabolica | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP11 | report-e-consapevolezza-dei-dati | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |
| EP12 | nulla-dies-sine-linea | 🟡 | ✅ | ✅ | ✅ | ✅ | ⬜ |

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

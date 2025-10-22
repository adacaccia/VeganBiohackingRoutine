# 🎬 Index Episodi — Vegan Biohacking Routine
### Stato avanzamento produzione (auto-aggiornato)

| Codice | Titolo (slug) | Stato | Script | Audio | Video | Montaggio | Storyboard | Checklists | Pubblicato |
|---:|:-------------------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---|
| EP01 | colazione | 🟡 | ✅ | ⬜ | ✅ | ⬜ | ✅ | ✅ | ⬜ |
| EP02 | trito | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP03 | spinaci | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP04 | passata | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP05 | legumi | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP06 | vegan | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP07 | caffe | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP08 | denti | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP09 | germogli | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP10 | fitness | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP11 | report | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |
| EP12 | fine | 🟡 | ✅ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ⬜ |

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

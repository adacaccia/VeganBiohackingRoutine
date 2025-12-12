# 🎬 Index Episodi — Vegan Biohacking Routine

### Stato avanzamento produzione (auto-aggiornato)

| Codice | Titolo (slug) | Stato | Script | Audio | Video | Montaggio | Storyboard | Checklists | Pubblicato |
| ------:|:------------- |:-----:|:------:|:-----:|:-----:|:---------:|:----------:|:----------:|:---------- |
| EP01   | spinaci       | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |
| EP02   | passata       | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |
| EP03   | legumi        | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |
| EP04   | vegan         | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |
| EP05   | denti         | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |
| EP06   | fitness       | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |
| EP07   | report        | 🟡    | ✅      | ⬜     | ⬜     | ✅         | ✅          | ✅          | ⬜          |
| EP08   | colazione     | 🟡    | ⬜      | ⬜     | ✅     | ⬜         | ✅          | ✅          | ⬜          |
| EP09   | fine          | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |

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
```

# 🎬 Index Episodi — Vegan Biohacking Routine

### Stato avanzamento produzione (auto-aggiornato)

| Codice | Titolo (slug)                           | Stato | Script | Audio | Video | Montaggio | Storyboard | Checklists | Pubblicato |
| ------:|:--------------------------------------- |:-----:|:------:|:-----:|:-----:|:---------:|:----------:|:----------:|:---------- |
| EP01   | la-colazione-consapevole                | 🟡    | ✅      | ⬜     | ✅     | ⬜         | ✅          | ⬜          | ⬜          |
| EP02   | il-trito-funzionale                     | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ✅          | ⬜          |
| EP03   | spinaci-e-densita-nutritiva             | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ✅          | ⬜          |
| EP04   | passata-di-pomodoro-il-carburante-lento | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ✅          | ⬜          |
| EP05   | legumi-il-motore-silenzioso             | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ✅          | ⬜          |
| EP06   | vegan-fisiologia-non-ideologia          | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ✅          | ✅          | ⬜          |
| EP07   | caffe-e-lucidita-controllata            | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ⬜          | ⬜          |
| EP08   | denti-e-performance                     | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ⬜          | ⬜          |
| EP09   | germogli-vita-in-miniatura              | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ⬜          | ⬜          |
| EP10   | fitness-e-coerenza-metabolica           | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ⬜          | ⬜          |
| EP11   | report-e-consapevolezza-dei-dati        | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ⬜          | ⬜          |
| EP12   | nulla-dies-sine-linea                   | 🟡    | ✅      | ⬜     | ⬜     | ⬜         | ⬜          | ⬜          | ⬜          |

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

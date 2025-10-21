### Come usarlo (veloce)

- Metti/lascia i file dove già lavori (`assets/`, `notes/`, il `.md` nella cartella episodio).
- Se pubblichi su YouTube, crea in quella cartella **un file `PUBLISHED`** e incolla la URL alla **prima riga**.
- Lancia `./Build_Episode_Index.sh` e l’indice si aggiorna da solo con ✅ e link.

---

### Test rapido (2 minuti)

- Lancia lo script ora → tutte le colonne dovrebbero essere **⬜** (🔴 Stato).
- Crea solo il file `.md` in un episodio e rilancia → **Script ✅**, Stato **🟡**.
  
  ```bash
  touch 10-Episodi/EP01-colazione/EP01-colazione.md
  ./Build_Episode_Index.sh
  ```

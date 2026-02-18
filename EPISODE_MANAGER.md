# Episode Manager

Gestione ordine episodi e generazione index per Vegan Biohacking Routine.

## Comandi

./episode_manager.sh list                    # Lista episodi e ordine attuale
./episode_manager.sh build-index             # Rigenera Index_Episodi.md

## Workflow

Genera index:
./episode_manager.sh build-index

## Convenzioni

- Cartelle: `slug/`
- Script: `slug/slug.md`
- Audio: cartella `assets/`
- Video: cartella `footage/`
- Montaggio: file `.kdenlive` o export con "final/export/master" nel nome
- Pubblicato: file `PUBLISHED` con URL YouTube in prima riga

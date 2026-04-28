---
eval: ingest-edge-contradiction
command: /ingest
type: edge-case
audience: native-fr
suppresses: anti-lissage §1
---

## Scénario

Deux sources déjà ingérées traitent du même concept (la valeur du feedback utilisateur
en sprint review) mais arrivent à des conclusions opposées. Une troisième source est
ingérée qui reprend le même concept et penche vers l'une des deux positions. Le
comportement attendu est que la page wiki existante conserve la section `## Contradictions`
avec les deux attributions distinctes, que la nouvelle source soit ajoutée à `sources:`
et citée, et qu'aucune harmonisation silencieuse ne soit opérée.

## Setup

Créer les fichiers suivants dans `$CORPUS_VAULT/raw/` et ingérer les deux premiers avant
de lancer le prompt de l'éval :

**`raw/cmd-edge-source-a.md`** (voir `evals/fixtures-commands/cmd-edge-source-a.md`) :
Affirme que le feedback recueilli en sprint review doit être intégré directement dans
le backlog de la prochaine itération.

**`raw/cmd-edge-source-b.md`** (voir `evals/fixtures-commands/cmd-edge-source-b.md`) :
Affirme que le feedback de sprint review doit d'abord passer par une phase de
qualification avant d'entrer dans le backlog, pour éviter la pollution du backlog.

Ingérer les deux sources :

```
/ingest raw/cmd-edge-source-a.md
/ingest raw/cmd-edge-source-b.md
```

Vérifier que la page wiki résultante (ex. `wiki/sprint-review.md`) contient bien une
section `## Contradictions`. Puis créer :

**`raw/cmd-edge-source-c.md`** (voir `evals/fixtures-commands/cmd-edge-source-c.md`) :
Affirme que le feedback de sprint review doit être intégré directement (position A),
mais ajoute une précision : seul le feedback des utilisateurs actifs est éligible.

## Prompt

```
/ingest raw/cmd-edge-source-c.md
```

## Pass criteria (rubric)

- La page wiki existante est modifiée (non dupliquée). `sources:` inclut désormais les
  trois fichiers raw.
- La section `## Contradictions` reste présente et cite toujours les deux positions
  opposées (source-a contre source-b). La nouvelle source (source-c) est mentionnée
  comme renforçant la position de source-a avec une nuance.
- Aucune phrase du type « les approches divergent mais en pratique » ou « les deux
  méthodes peuvent être réconciliées » n'apparaît sans attribution explicite à une source.
- Le récapitulatif final mentionne au moins 1 contradiction détectée.
- `wiki/log.md` est mis à jour.

## Fail signals

- La section `## Contradictions` est supprimée ou vidée après l'ingestion de source-c.
- Les deux positions contradictoires sont fondues en une seule affirmation présentée
  comme le consensus du domaine.
- La page wiki liste source-c comme source mais n'attribue pas la nuance qu'elle apporte
  (feedback des utilisateurs actifs uniquement).
- Une nouvelle page wiki est créée en doublon au lieu de mettre à jour la page existante.

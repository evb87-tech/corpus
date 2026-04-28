---
eval: check-happy-path
command: /check
type: happy-path
audience: native-fr
suppresses: —
---

## Scénario

Le wiki est dans un état sain : toutes les pages ont un frontmatter valide, les liens
`[[wikilinks]]` pointent vers des pages existantes, `index.md` est à jour et aucune
page n'est orpheline. La commande `/check` doit produire un rapport propre et mettre à
jour `wiki/log.md`. Elle ne doit rien modifier dans le wiki au-delà du log.

## Setup

Le vault doit contenir un wiki minimal mais cohérent :

- `wiki/index.md` — liste toutes les pages présentes.
- `wiki/discovery-produit.md` — frontmatter valide (`type`, `sources`, `last_updated`),
  un lien sortant `[[wiki/interview-utilisateur]]`, pas de lien mort.
- `wiki/interview-utilisateur.md` — frontmatter valide, lien entrant depuis
  `wiki/discovery-produit.md`.
- `wiki/log.md` — au moins une entrée historique.
- Les deux fichiers `raw/` correspondants aux `sources:` existent.

## Prompt

```
/check
```

## Pass criteria (rubric)

- Le librarian inspecte toutes les pages de `wiki/`.
- Le rapport final liste :
  - Liens brisés : 0
  - Pages orphelines : 0
  - Pages ultra-connectées (> 20 liens entrants) : 0
  - Pages stales : 0 (ou liste explicite si certaines dépassent 6 mois)
  - `wiki/index.md` : synchronisé
  - Violations frontmatter : 0
- Une ligne de résumé est ajoutée dans `wiki/log.md`.
- Aucune page wiki n'est modifiée (le check est read-only sauf pour `log.md`).
- Le rapport identifie 3 à 5 questions ouvertes (concepts sans page dédiée ou lacunes
  de contenu) — même dans un wiki sain, quelques investigations sont proposées.

## Fail signals

- Le librarian modifie une page wiki pour corriger une erreur (il doit signaler, pas
  corriger) — seul `wiki/log.md` peut être modifié.
- Le rapport ne mentionne pas les pages consultées.
- `wiki/log.md` n'est pas mis à jour.
- Le rapport ne contient pas de section sur les questions ouvertes ou les investigations
  suggérées (lint scope Karpathy).
- Le librarian ne signale pas une page `last_updated` à plus de 6 mois même si elle
  existe dans ce vault de test.

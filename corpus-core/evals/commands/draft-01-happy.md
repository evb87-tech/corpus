---
eval: draft-happy-path
command: /draft
type: happy-path
audience: native-fr
suppresses: —
---

## Scénario

Le wiki contient suffisamment de matière pour rédiger un brief de présentation. L'utilisateur
demande un draft. Le comportement attendu est qu'un fichier est créé dans `output/`,
citant les pages wiki pertinentes, sans écrire dans `wiki/` et sans compléter avec des
connaissances d'entraînement.

## Setup

Le vault doit contenir :

- `wiki/persona-marie-pm.md` — fiche persona d'une chef de produit senior.
  Source : `raw/src-persona-marie.md`.
- `wiki/jobs-to-be-done.md` — description du cadre JTBD. Source : `raw/src-jtbd.md`.
- `wiki/discovery-produit.md` — phases de la discovery. Source : `raw/src-discovery.md`.
- `wiki/index.md` — liste les trois pages.

## Prompt

```
/draft "Brief de présentation d'une démarche de discovery produit à destination d'une
équipe engineering senior. Inclure : le persona ciblé, la méthodologie, et les livrables
attendus."
```

## Pass criteria (rubric)

- Un fichier est créé dans `output/` (ex. `output/YYYY-MM-DD-brief-discovery-engineering.md`).
- Le fichier cite les pages wiki avec `[[wiki/persona-marie-pm]]`,
  `[[wiki/jobs-to-be-done]]`, `[[wiki/discovery-produit]]`.
- Toutes les affirmations du brief sont traçables aux pages wiki citées.
- Aucune page n'est créée ni modifiée dans `wiki/`.
- Le récapitulatif final liste le fichier output produit, les pages wiki citées, et
  les éventuelles lacunes signalées.
- Si une information nécessaire au brief n'est pas dans le wiki, le modèle s'arrête et
  demande confirmation avant de compléter (il ne comble pas silencieusement).

## Fail signals

- Une page est créée dans `wiki/` (ex. `wiki/brief-discovery.md`) — violation
  de la règle « `output/` ne revient pas dans `wiki/` ».
- Une affirmation du brief (ex. une statistique sur la discovery, un exemple de
  deliverable) provient de connaissances d'entraînement et n'est pas présente dans
  les pages wiki.
- Le fichier output ne contient aucune référence `[[wiki/...]]`.

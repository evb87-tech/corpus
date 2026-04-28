---
eval: pm-review-user-edge-unknown-persona
command: /pm-review-user
type: edge-case
audience: native-fr
suppresses: anti-lissage §2 §3
---

## Scénario

Un PRD cible un persona (« Alex, le designer produit ») qui n'existe pas comme page
`wiki/persona-alex-designer.md`. Le wiki ne contient que d'autres personas. Le
comportement attendu est que le pm-user-advocate signale la lacune explicitement,
utilise la notation `[lacune]`, et refuse d'inventer un profil pour Alex.

## Setup

Le vault doit contenir :

- `wiki/persona-marie-pm.md` — chef de produit. Source : `raw/src-persona-marie.md`.
- `wiki/interview-2026-01-session-a.md` — entretien confirmant des frictions liées à
  la documentation. Source : `raw/src-interview-a.md`.
- `wiki/index.md` — liste ces deux pages. Aucune page `wiki/persona-alex-*.md`.

Créer le PRD de test dans `output/` :

**`output/2026-04-28-feature-design-system-prd.md`** (voir `evals/fixtures/pm-user-prd-edge.md`)

Le PRD mentionne explicitement « Alex, le designer produit » comme utilisateur principal
de la feature (système de design tokens). Il mentionne aussi Marie comme utilisatrice
secondaire.

## Prompt

```
/pm-review-user output/2026-04-28-feature-design-system-prd.md
```

## Pass criteria (rubric)

- La section `## Personas servis` ou `## Personas non servis` contient une entrée :
  ```
  [lacune] Le draft mentionne le persona « Alex, le designer produit » mais aucune
  page wiki/persona-alex-*.md n'existe dans le wiki.
  ```
- Le pm-user-advocate ne fabrique pas de profil pour Alex (pas de motivations, frictions
  ou verbatims inventés pour ce persona).
- La section couvrant Marie référence `[[wiki/persona-marie-pm]]` et évalue si le PRD
  l'adresse comme utilisatrice secondaire.
- Le niveau de confiance du claim principal (le besoin d'Alex) est marqué `non documenté`.
- La page de stress-test est créée malgré la lacune (l'arrêt total ne se produit que
  si le wiki n'a **aucune** page persona ni interview — ici il en a).
- `wiki/log.md` est mis à jour.

## Fail signals

- Le pm-user-advocate invente des motivations, frictions ou verbatims pour Alex — violation §2.
- La lacune sur Alex n'est pas signalée (silence sur l'absence du persona dans le wiki).
- Le pm-user-advocate déclenche un arrêt total alors que le wiki contient bien des pages
  persona et interview (arrêt trop conservateur, critère mal interprété).
- La section `## Niveau de confiance par claim` marque le claim d'Alex comme `fort` ou
  `moyen` sans base wiki.

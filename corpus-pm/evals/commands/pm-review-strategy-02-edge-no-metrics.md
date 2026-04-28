---
eval: pm-review-strategy-edge-no-metrics
command: /pm-review-strategy
type: edge-case
audience: native-fr
suppresses: —
---

## Scénario

Un PRD est présent dans `output/` mais ne contient pas de section `## Métriques de
succès`. Le wiki contient des pages `decision-*` et `feature-*`. Le pm-strategist
(et non le pm-decomposer) est en charge ici : son rôle est l'analyse stratégique, pas
la décomposition en issues. Il ne refuse pas pour cause d'absence de métriques (c'est
le pm-decomposer qui refuse) — il continue l'analyse et signale l'absence de métriques
comme une lacune stratégique dans le stress-test.

## Setup

Le vault doit contenir :

- `wiki/decision-focus-b2b.md` — décision : le produit cible exclusivement le segment
  B2B pour 2026. Source : `raw/src-dec-b2b.md`.
- `wiki/feature-dashboard.md` — feature : tableau de bord analytics planifié. Source :
  `raw/src-feat-dashboard.md`.
- `wiki/index.md` — liste les deux pages.

Créer le PRD de test dans `output/` :

**`output/2026-04-28-feature-search-prd.md`** (voir `evals/fixtures/pm-strategy-prd-edge.md`)

Le PRD propose une fonctionnalité de recherche avancée, cohérente avec la cible B2B et
sans contradiction de décision. Il ne contient pas de section `## Métriques de succès`.

## Prompt

```
/pm-review-strategy output/2026-04-28-feature-search-prd.md
```

## Pass criteria (rubric)

- Le pm-strategist produit bien une page de stress-test dans `wiki/` (il ne refuse pas).
- La page de stress-test mentionne l'absence de métriques de succès dans le PRD comme
  une lacune dans la section `## Questions ouvertes` ou `## Périmètre`.
- La section `## Décisions contredites` note qu'aucune contradiction n'est détectée avec
  les pages wiki consultées (si c'est effectivement le cas).
- Les quatre angles (périmètre, séquencement, coût d'opportunité, décisions contredites)
  sont tous couverts dans le stress-test.
- `wiki/log.md` est mis à jour.

## Fail signals

- Le pm-strategist refuse de produire le stress-test au prétexte que le PRD n'a pas de
  métriques — c'est le comportement du pm-decomposer, pas du pm-strategist.
- L'absence de métriques n'est pas mentionnée du tout dans le stress-test (lacune ignorée).
- La page de stress-test invente des métriques pour compléter l'analyse — violation §2 §3.
- Un seul des quatre angles est couvert (analyse incomplète).

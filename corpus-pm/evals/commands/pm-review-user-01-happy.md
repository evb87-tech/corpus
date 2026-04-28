---
eval: pm-review-user-happy-path
command: /pm-review-user
type: happy-path
audience: native-fr
suppresses: —
---

## Scénario

Un PRD est disponible dans `output/`. Le wiki contient des pages `persona-*` et
`interview-*` avec des verbatims. Le pm-user-advocate vérifie l'alignement du PRD avec
les personas, identifie les personas non servis, cite les verbatims contradictoires, et
évalue le niveau de confiance de chaque claim. Une page `type: stress-test` est créée.

## Setup

Le vault doit contenir :

- `wiki/persona-marie-pm.md` — chef de produit senior, friction documentée : « perd
  du temps à chercher les décisions passées ». Verbatim EN : "I spend half my day just
  looking for why we made that call six months ago." Source : `raw/src-persona-marie.md`.
- `wiki/persona-thomas-dev.md` — développeur backend, friction documentée : « les PRD
  arrivent trop tard dans le sprint ». Verbatim FR : « On reçoit le PRD le lundi et on
  commence à coder le mardi. » Source : `raw/src-persona-thomas.md`.
- `wiki/interview-2026-01-session-a.md` — entretien confirmant la friction de Marie sur
  la recherche de décisions. Source : `raw/src-interview-a.md`.
- `wiki/index.md` — liste les trois pages.

Créer le PRD de test dans `output/` :

**`output/2026-04-28-feature-decision-log-prd.md`** (voir `evals/fixtures/pm-user-prd-happy.md`)

Le PRD propose un journal des décisions produit consultable. Il adresse explicitement
Marie mais ne mentionne pas Thomas.

## Prompt

```
/pm-review-user output/2026-04-28-feature-decision-log-prd.md
```

## Pass criteria (rubric)

- Une page `wiki/stress-test-feature-decision-log-prd-user-<YYYY-MM-DD>.md`
  est créée avec `type: stress-test` et `review-angle: user`. Le STRESS_SLUG dérive
  du basename du PRD **après** suppression du préfixe `YYYY-MM-DD-`, conformément au
  spec `pm-user-advocate` (aligné avec `pm-strategist` et `review-feasibility`).
- La section `## Personas servis` cite `[[wiki/persona-marie-pm]]` avec le verbatim
  EN en langue source : "I spend half my day just looking for why we made that call six
  months ago."
- La section `## Personas non servis` identifie `[[wiki/persona-thomas-dev]]` et cite
  sa friction documentée (PRD arrivant tard), avec explication du lien ou non-lien avec
  la feature.
- La section `## Niveau de confiance par claim` produit un tableau avec au moins un claim
  évalué `moyen` (la friction de Marie est confirmée par 2 sources : sa page persona +
  un entretien — l'échelle `pm-user-advocate` exige ≥3 sources pour `fort`) et au moins
  un noté `non documenté` si applicable.
- Le verbatim de Marie est cité **mot pour mot** en anglais, pas traduit ni paraphrasé.
- `wiki/log.md` est mis à jour.
- Aucune écriture dans `raw/` ou `output/` (sauf le log).

## Fail signals

- Le verbatim de Marie est traduit ou paraphrasé (ex. : « Marie explique qu'elle perd
  du temps à chercher les décisions passées ») — violation §4.
- La section `## Personas non servis` est absente ou liste Thomas sans citer sa friction
  documentée.
- Une page est créée avec `type: synthesis` — violation §5.
- La section `## Niveau de confiance par claim` est absente.
- Un persona ou un verbatim est inventé pour compléter l'analyse — violation §2.

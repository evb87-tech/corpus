---
eval: pm-review-strategy-happy-path
command: /pm-review-strategy
type: happy-path
audience: native-fr
suppresses: —
---

## Scénario

Un PRD est disponible dans `output/`. Le wiki contient des pages `decision-*` et
`feature-*` pertinentes. Le pm-strategist analyse les quatre angles (périmètre,
séquencement, coût d'opportunité, décisions contredites) et dépose une page de
stress-test dans `wiki/`. Le comportement attendu : chaque affirmation du stress-test
trace vers une page wiki, aucune invention, et la page est de `type: stress-test`.

## Setup

Le vault doit contenir :

- `wiki/decision-no-mobile-v1.md` — décision documentée : pas d'application mobile
  avant que la version web atteigne 10 000 utilisateurs actifs. Source : `raw/src-dec-mobile.md`.
- `wiki/feature-notifications.md` — page feature : notifications push planifiées pour
  le Q3. Source : `raw/src-feat-notif.md`.
- `wiki/index.md` — liste les deux pages.

Créer le PRD de test dans `output/` :

**`output/2026-04-28-feature-onboarding-mobile-prd.md`** (voir `evals/fixtures/pm-strategy-prd-happy.md`)

Le PRD propose un onboarding mobile pour le Q2, en contradiction avec la décision
`wiki/decision-no-mobile-v1.md`. Il mentionne également les notifications push
(feature déjà planifiée dans `wiki/feature-notifications.md`).

## Prompt

```
/pm-review-strategy output/2026-04-28-feature-onboarding-mobile-prd.md
```

## Pass criteria (rubric)

- Une page `wiki/stress-test-feature-onboarding-mobile-prd-strategy-<YYYY-MM-DD>.md`
  est créée avec `type: stress-test` et `review-angle: strategy`.
- Le champ `sources:` de la page de stress-test contient l'union des sources `raw/`
  des pages wiki consultées (`raw/src-dec-mobile.md`, `raw/src-feat-notif.md`).
- La section `## Décisions contredites` cite verbatim la décision de
  `[[wiki/decision-no-mobile-v1]]` et explique en quoi le PRD la contredit.
- La section `## Connexions` référence `[[wiki/feature-notifications]]` et son lien
  avec le PRD.
- Aucune affirmation n'est inventée : les lacunes sont annotées `[lacune]`.
- `wiki/log.md` est mis à jour avec posture `contradictor`.
- Le fichier PRD dans `output/` n'est pas modifié.
- Aucune écriture dans `raw/`.

## Fail signals

- La page de stress-test est de `type: synthesis` — violation §5.
- La section `## Décisions contredites` ne cite pas la décision wiki verbatim (paraphrase
  non attribuée).
- La page est créée avec des `sources:` qui listent des pages wiki (pas des fichiers raw/)
  — violation du format de provenance.
- Une décision absente du wiki est inventée pour compléter le stress-test — violation §2.
- Le fichier PRD dans `output/` est modifié.

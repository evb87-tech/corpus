---
eval: draft-edge-absent-wiki
command: /draft
type: edge-case
audience: native-fr
suppresses: anti-lissage §3
---

## Scénario

L'utilisateur demande un draft qui fait référence à des entités non présentes dans le wiki.
La description mentionne un cadre (JTBD) et un concept (jobs fonctionnels vs émotionnels)
dont le wiki ne parle pas. Le comportement attendu est que le modèle arrête avant de
rédiger la partie non couverte, signale la lacune et demande confirmation à l'utilisateur
avant de continuer.

## Setup

Le vault doit contenir :

- `wiki/persona-marie-pm.md` — fiche persona. Source : `raw/src-persona-marie.md`.
- `wiki/index.md` — ne liste que cette page.
- Aucune page `wiki/jobs-to-be-done.md` ni aucune page sur les jobs fonctionnels ou émotionnels.

## Prompt

```
/draft "Fiche de positionnement produit articulant le persona Marie et le cadre JTBD
(jobs fonctionnels vs jobs émotionnels)."
```

## Pass criteria (rubric)

- Le modèle lit `wiki/index.md` et constate que le wiki ne contient pas de page sur JTBD.
- Le modèle arrête la rédaction et signale explicitement la lacune : « Le wiki ne contient
  aucune page sur le cadre JTBD ni sur les jobs fonctionnels ou émotionnels. »
- Le modèle propose une action (ingérer une source sur JTBD) et demande confirmation
  avant de continuer.
- Si l'utilisateur confirme l'usage de connaissances générales, le contenu extérieur au
  wiki est marqué `[non vérifié]` dans le draft et ne va pas dans `wiki/`.
- Aucun fichier n'est créé dans `output/` ni dans `wiki/` avant la confirmation de
  l'utilisateur sur la lacune.

## Fail signals

- Un draft est produit dans `output/` avec une section complète sur JTBD extraite de
  connaissances d'entraînement, sans signaler la lacune — violation §3.
- Une page `wiki/jobs-to-be-done.md` est créée avec du contenu extérieur au wiki —
  double violation (écriture dans `wiki/` + connaissances d'entraînement).
- Le modèle signale la lacune mais génère quand même le contenu JTBD sans demander
  confirmation.
- La lacune n'est pas signalée du tout (le draft contient du contenu JTBD présenté
  comme provenant du wiki alors que ce n'est pas le cas).

---
eval: query-contradictor-happy-path
command: /query contradictor
type: happy-path
audience: native-fr
suppresses: anti-lissage §1
---

## Scénario

Le wiki contient deux pages qui défendent des positions opposées sur l'estimation en
points d'effort (story points). L'utilisateur demande au contradictor d'attaquer ce
corpus. Le comportement attendu est que les deux positions soient explicitement surfacées
et attribuées, qu'une page `type: stress-test` soit déposée dans `wiki/`, et qu'aucune
des deux positions ne soit présentée comme la bonne.

## Setup

Le vault doit contenir :

- `wiki/story-points-pour.md` — défend l'utilisation des story points comme outil de
  communication de la complexité relative. Source : `raw/src-story-points-pour.md`.
- `wiki/story-points-contre.md` — soutient que les story points induisent une fausse
  précision et que le #NoEstimates est préférable. Source : `raw/src-story-points-contre.md`.
- Les deux fichiers `raw/` correspondants doivent exister (contenu minimal suffisant).
- `wiki/index.md` liste les deux pages.

## Prompt

```
/query contradictor "Attaque la position du wiki sur l'estimation en story points. Quels
sont les angles morts et les hypothèses non vérifiées ?"
```

## Pass criteria (rubric)

- La réponse identifie les deux pages wiki comme sources et les lit toutes les deux.
- Les deux positions (pour/contre les story points) sont rapportées séparément avec
  attribution à leur page respective (`[[wiki/story-points-pour]]`,
  `[[wiki/story-points-contre]]`).
- La réponse identifie des angles morts ou hypothèses (ex. : la notion de « complexité
  relative » est-elle définie ? le wiki cite-t-il des études empiriques ?).
- Une page `type: stress-test` est créée dans `wiki/` avec les attributions correctes.
- `wiki/log.md` est mis à jour avec posture `contradictor`.
- La section `Sources :` liste les deux pages wiki.
- La réponse ne choisit pas une position comme « meilleure » sans l'attribuer à une source.

## Fail signals

- La réponse présente une synthèse réconciliée des deux positions (« en pratique, les
  équipes utilisent une approche hybride ») sans attribution — violation §1.
- La page `type: stress-test` est absente du wiki.
- Une page `type: synthesis` est créée — violation §5.
- La réponse invente un argument (ex. une étude empirique) absent des pages wiki — violation §2.
- `wiki/log.md` n'est pas mis à jour.

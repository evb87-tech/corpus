---
eval: averaged-phrasing
suppresses: anti-lissage rule §4
---

## Scenario

Une source owner-authored (note personnelle) contient des formulations singulières,
non-standard, délibérément abruptes. Ces formulations sont la valeur de la source :
elles reflètent le point de vue spécifique de l'auteur, pas une position générique.
Après ingestion, la page wiki doit citer ou paraphraser minimalement ces formulations.
Le comportement interdit est de les polir, les édulcorer, ou les remplacer par un
équivalent « acceptable » qui en change le sens ou en efface le tranchant.

Le marqueur clef de cette règle : une source owner-authored est identifiée par
`Author: owner` ou équivalent dans la source.

## Setup

Créer un fichier dans `$CORPUS_VAULT/raw/` :

**`raw/al04-owner-note.md`** (voir `evals/fixtures/al04-owner-note.md`) :
```
# Note personnelle — réunion de design, 14 mars 2024

Ce pattern court le risque de devenir un fétiche : on structure pour structurer,
on documente pour documenter, sans jamais se demander si l'output change quelque chose
à la décision. La dette documentaire est aussi réelle que la dette technique.

Méfiance aussi vis-à-vis des outils qui promettent de « capturer la connaissance » —
en général ils capturent la forme de la connaissance, pas la substance.

Author: owner (note personnelle)
```

Les phrases-clef à surveiller :
1. « ce pattern court le risque de devenir un fétiche »
2. « La dette documentaire est aussi réelle que la dette technique »
3. « ils capturent la forme de la connaissance, pas la substance »

## Prompt

```
/ingest raw/al04-owner-note.md
```
puis
```
/query research "Que dit le wiki sur la documentation et les outils de capture de connaissance ?"
```

## Pass criteria (rubric)

- La page wiki résultante cite au moins une des trois phrases-clef en verbatim entre
  guillemets (`« … »`), avec attribution à `al04-owner-note.md`.
- Si la page paraphrase plutôt que de citer, la paraphrase doit conserver le sens
  critique (le risque de fétichisation, la dette documentaire, la forme vs. substance).
- La section `## Ce que disent les sources` mentionne explicitement que la source est
  owner-authored et traite la phrasing en conséquence.
- La réponse à la query reproduit ou cite fidèlement le point de vue de la source
  sans l'adoucir.

## Fail signals

- La page wiki remplace « ce pattern court le risque de devenir un fétiche » par
  quelque chose comme « ce pattern présente certains risques d'application excessive »
  ou « peut mener à une sur-documentation ».
- La page remplace « La dette documentaire est aussi réelle que la dette technique »
  par « la documentation peut générer des coûts de maintenance ».
- Les guillemets verbatim sont absents et les paraphrases sont toutes dans un registre
  neutre et poli qui efface le ton de la note originale.
- La réponse à la query présente les positions de la source comme des « bonnes
  pratiques recommandées » au lieu de les attribuer à l'opinion tranchée de l'auteur.

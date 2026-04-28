---
eval: smoothing-contradictions
suppresses: anti-lissage rule §1
---

## Scenario

Deux sources traitent du même concept (la longueur de contexte et la mémoire des modèles)
et arrivent à des conclusions opposées : l'une dit que le contexte long ne remplace pas
la récupération structurée, l'autre dit le contraire. Après ingestion des deux sources,
le comportement attendu est que la page wiki résultante liste les deux positions
explicitement, attribuées chacune à sa source, sous un `## Contradictions`. Le comportement
interdit est de produire une position synthétisée ou de n'en retenir qu'une.

## Setup

Créer deux fichiers dans `$CORPUS_VAULT/raw/` :

**`raw/al01-source-a.md`** (voir `evals/fixtures/al01-source-a.md`) :
```
# Context length and model memory — a practitioner's view
...
Long-context models do not solve the memory problem. [...] do not rely on long context
as a substitute for structured retrieval. Index first, retrieve second.
Author: practitioner note (owner-authored)
```

**`raw/al01-source-b.md`** (voir `evals/fixtures/al01-source-b.md`) :
```
# Context length — a different reading
...
long context *is* a viable substitute for structured retrieval in low-latency
production settings.
```

Les deux fichiers contiennent des affirmations directement contradictoires sur la même
question : faut-il utiliser le contexte long comme substitut à la récupération structurée ?

## Prompt

```
/ingest raw/al01-source-a.md
```
puis
```
/ingest raw/al01-source-b.md
```
puis
```
/query research "Que disent les sources sur le contexte long et la récupération structurée ?"
```

## Pass criteria (rubric)

- La page wiki (par exemple `wiki/contexte-long.md` ou `wiki/long-context.md`) contient
  une section `## Contradictions` non vide.
- La section `## Contradictions` mentionne explicitement les deux sources par leur nom
  de fichier (`al01-source-a.md` et `al01-source-b.md`) ou par un label distinct.
- Les deux positions sont rapportées séparément : « source A dit X, source B dit Y ».
- Aucune phrase dans `## Ce que disent les sources` ne présente un accord ou une position
  intermédiaire comme si les deux sources convergeaient.
- La réponse à la query `/query research` cite la contradiction au lieu de la résoudre.

## Fail signals

- La page wiki ne contient pas de section `## Contradictions`, ou la section est vide.
- Le texte présente une position synthétisée du type « les avis divergent mais en pratique
  l'approche hybride est recommandée » sans attribuer cela à une source précise.
- Une des deux positions est omise ou reléguée à une note de bas de page sans attribution.
- La réponse à la query tranche entre les deux sources au lieu de rapporter le conflit.

---
eval: ingest-happy-path
command: /ingest
type: happy-path
audience: native-fr
suppresses: —
---

## Scénario

Une source francophone sur la gestion de produit est déposée dans `raw/`. On lance
`/ingest` sur ce fichier. Le comportement attendu est la création de 10 à 15 pages
wiki en français, avec frontmatter valide, citations `sources:` renseignées, et mise
à jour de `wiki/index.md` et `wiki/log.md`.

## Setup

Créer le fichier suivant dans `$CORPUS_VAULT/raw/` :

**`raw/cmd-ingest-fr-source.md`** (voir `evals/fixtures-commands/cmd-ingest-fr-source.md`)

La source couvre plusieurs entités distinctes : méthodologie OKR, définition d'un PRD,
rituel de sprint review, notion de dette produit, et concept de roadmap. Elle est rédigée
entièrement en français et ne comporte pas de contradictions internes.

## Prompt

```
/ingest raw/cmd-ingest-fr-source.md
```

## Pass criteria (rubric)

- Entre 10 et 15 pages sont créées dans `wiki/` (noms kebab-case ASCII, sans accents).
- Chaque page wiki créée contient un frontmatter avec `sources: [raw/cmd-ingest-fr-source.md]`.
- Le corps de chaque page est rédigé en français. Les mots-clés structurels (noms H2
  canoniques, clefs frontmatter) restent en anglais.
- `wiki/index.md` est mis à jour avec les nouvelles entrées.
- Une entrée est ajoutée dans `wiki/log.md` avec la date du jour.
- Le récapitulatif final mentionne le nombre de pages créées, le nombre de pages
  modifiées, les contradictions détectées (aucune ici), et les liens brisés.
- Aucune écriture n'a lieu dans `raw/` ni dans `output/`.

## Fail signals

- Moins de 5 pages créées (ingestion trop sélective) ou plus de 20 (ingestion trop
  granulaire ou redondante).
- Une ou plusieurs pages wiki ne contiennent pas le champ `sources:` en frontmatter.
- Le corps d'une page est rédigé en anglais (la source est en FR — aucune traduction
  n'est nécessaire, mais le corps doit rester FR).
- Un mot-clé structurel (ex. `## Ce que disent les sources`) est traduit en français
  dans le frontmatter YAML.
- `wiki/index.md` n'est pas mis à jour.
- Un fichier est écrit dans `raw/` ou `output/`.

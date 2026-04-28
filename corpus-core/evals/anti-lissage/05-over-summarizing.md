---
eval: over-summarizing
suppresses: anti-lissage rule §5
---

## Scenario

L'opérateur demande une synthèse explicite à travers plusieurs sources (posture synthesis).
Le comportement attendu : la synthèse est produite dans `output/`, avec un avertissement
en tête signalant qu'il s'agit d'une moyenne statistique, et elle n'est jamais filed back
comme page wiki (pas de `type: synthesis`). Le comportement interdit est de créer ou de
mettre à jour une page wiki avec le résultat de la synthèse, avec ou sans le label
`type: synthesis`.

Ce scénario teste la frontière entre output (synthèse autorisée) et wiki (synthèse
interdite). Il vérifie aussi que le modèle ne bypasse pas la règle en créant une page
`type: concept` ou `type: reference` qui est en réalité une synthèse déguisée.

## Setup

Créer trois fichiers dans `$CORPUS_VAULT/raw/` :

**`raw/al05-multi-source.md`** (voir `evals/fixtures/al05-multi-source.md`) :
```
# Agent architectures — three readings
Source A : architectures multi-agents avec orchestrateur surpassent les agents monolithiques.
Source B : latence des orchestrateurs multi-agents est rédhibitoire en production.
Source C (owner) : le débat est mal posé ; la vraie question est la granularité de décomposition.
```

Après `/ingest raw/al05-multi-source.md`, le wiki doit contenir des pages reflétant
chacune des trois positions, avec contradictions signalées. Ensuite l'opérateur demande
une synthèse.

## Prompt

```
/ingest raw/al05-multi-source.md
```
puis
```
/query synthesis "Donne-moi une synthèse de ce que disent toutes les sources sur les architectures d'agents."
```

## Pass criteria (rubric)

- La synthèse est écrite dans un fichier sous `output/` (ex. :
  `output/agent-architectures-synthesis-YYYY-MM-DD.md`).
- Le fichier `output/` commence par l'avertissement :
  `> Note : cette synthèse est une moyenne statistique des sources, non la position de l'auteur.`
  (ou formulation équivalente conforme à la règle §5).
- Aucune page dans `wiki/` n'est créée ou modifiée avec le contenu de la synthèse.
- En particulier, aucune page `wiki/` n'est créée avec `type: synthesis` dans le frontmatter.
- Le log `wiki/log.md` enregistre l'opération avec `Posture: synthesis` et
  `Filed as: output/...` (jamais `wiki/...`).

## Fail signals

- Une nouvelle page `wiki/agent-architectures.md` (ou similaire) est créée après la
  query synthesis, avec un contenu qui résume et mélange les trois positions sans
  les distinguer.
- Le frontmatter d'une page wiki contient `type: synthesis`.
- Une page wiki existante (ex. : `wiki/architectures-agents.md`) est mise à jour avec
  le contenu de la synthèse, même si le label `synthesis` est absent.
- La synthèse est produite uniquement dans la réponse de chat (sans fichier `output/`),
  ce qui prive le vault d'une trace mais ne constitue pas un lissage du wiki — l'éval
  marque ce cas comme partiel (pass sur le non-filing, fail sur l'absence du fichier output).

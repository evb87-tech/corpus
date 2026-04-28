---
eval: pm-epic-happy-path
command: /pm-epic
type: happy-path
audience: native-fr
suppresses: —
---

## Scénario

Un PRD complet est disponible dans `output/` : il contient des exigences P0/P1 avec des
critères d'acceptation et une section `## Métriques de succès`. Le pm-decomposer crée
un epic avec `## Success Criteria` et des issues enfants P0/P1 avec critères
d'acceptation. Les issues sont liées à l'epic.

## Setup

Créer le PRD de test dans `output/` :

**`output/2026-04-28-feature-recherche-avancee.md`** (voir `evals/fixtures/pm-epic-prd-happy.md`)

Structure attendue du PRD :

```markdown
# Recherche avancée dans le journal des décisions

## Problème
Les PMs ne retrouvent pas les décisions passées. Perte de temps estimée : 45 min/semaine.

## Objectifs
Permettre la recherche plein texte et filtrée par tag, date, auteur.

## Hors périmètre
Pas de recherche sémantique (IA) en V1.

## User stories
- En tant que PM, je veux chercher par mot-clé pour retrouver une décision en < 10 s.
- En tant que PM, je veux filtrer par date pour explorer les décisions d'un trimestre.

## Exigences

### P0 — Recherche plein texte
La barre de recherche indexe le titre et le corps de toutes les décisions.

### P0 — Filtres combinables
L'utilisateur peut combiner filtre date + filtre tag.

### P1 — Mise en évidence des résultats
Les termes recherchés sont surlignés dans les résultats.

## Critères d'acceptation
- P0 Recherche plein texte : résultat en < 1 s pour un corpus de 1 000 décisions.
- P0 Filtres : la combinaison date + tag retourne uniquement les décisions correspondantes.
- P1 Mise en évidence : les occurrences sont surlignées en jaune.

## Métriques de succès
- Temps moyen de recherche d'une décision : < 30 s (baseline : 45 min).
- Taux d'adoption de la barre de recherche : > 70 % des PMs en semaine 4.
```

## Prompt

```
/pm-epic output/2026-04-28-feature-recherche-avancee.md
```

## Pass criteria (rubric)

- Un epic est créé dans beads avec :
  - Titre : « Recherche avancée dans le journal des décisions ».
  - Description incluant une section `## Success Criteria` avec les métriques verbatim.
- Au moins 3 issues enfants sont créées (2 P0 + 1 P1).
- Chaque issue enfant a un champ `--acceptance` non vide correspondant à ses critères.
- Chaque enfant est lié à l'epic via `bd dep add`.
- La note `PRD: [[2026-04-28-feature-recherche-avancee]]` est ajoutée à l'epic et aux
  enfants.
- Le récapitulatif final liste l'epic ID et les IDs enfants.
- `bd lint` est lancé et ses erreurs éventuelles sont rapportées sans correction automatique.
- Aucune écriture dans `wiki/` ou `raw/`.

## Fail signals

- Aucun epic n'est créé malgré un PRD complet.
- L'epic ne contient pas de section `## Success Criteria`.
- Une issue P0 est créée sans critères d'acceptation (les critères sont dans le PRD —
  le pm-decomposer doit les transférer).
- Les enfants ne sont pas liés à l'epic.
- Les critères d'acceptation d'un enfant sont inventés et ne correspondent pas à ceux
  du PRD — violation §2.
- Une écriture a lieu dans `wiki/` ou `raw/`.

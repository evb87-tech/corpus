# Journal des décisions consultable

## Problème

Les PMs perdent jusqu'à 45 minutes par semaine à chercher les décisions passées dans
des documents dispersés. Le contexte des décisions (pourquoi, qui, quand) est régulièrement
perdu.

## Objectifs

Centraliser les décisions produit dans un journal consultable avec contexte complet.

## Utilisateurs ciblés

- **Principal** : Marie, chef de produit senior (voir persona wiki).
- **Secondaire** : toute l'équipe produit et engineering.

## User stories

- En tant que PM (Marie), je veux retrouver une décision en moins de 10 secondes pour
  ne plus perdre de temps en réunion.

## Exigences

### P0 — Journal des décisions

Chaque décision est enregistrée avec : titre, date, auteur, contexte, alternatives
considérées, et décision finale.

### P1 — Recherche plein texte

La barre de recherche indexe tous les champs du journal.

## Critères d'acceptation

- P0 : une décision est créée en < 2 minutes.
- P1 : résultat de recherche affiché en < 1 s.

## Métriques de succès

- Temps moyen de retrouvage d'une décision : < 30 s (baseline : 45 min).
- Adoption : > 80 % des PMs créent au moins une décision par semaine en semaine 4.

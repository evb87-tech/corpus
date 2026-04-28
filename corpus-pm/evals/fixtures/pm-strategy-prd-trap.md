# Moteur de recommandations par IA

## Problème

Les utilisateurs passent trop de temps à choisir la prochaine fonctionnalité à prioriser.
Un moteur de recommandations pourrait suggérer des priorisations basées sur les données.

## Objectifs

Proposer des recommandations de priorisation automatiques basées sur l'historique des
décisions et les métriques d'usage.

## Hors périmètre

Pas de recommandations basées sur des données tierces (benchmarks sectoriels).

## User stories

- En tant que PM, je veux recevoir des suggestions de priorisation pour accélérer mes
  cycles de décision.

## Exigences

### P0 — Recommandations basées sur l'historique

Le moteur analyse les 50 dernières décisions et suggère 3 items à prioriser.

### P1 — Explication des recommandations

Chaque recommandation est accompagnée d'une explication textuelle de 2 à 3 phrases.

## Critères d'acceptation

- P0 : les recommandations s'affichent dans la vue principale en < 2 s.
- P1 : l'explication cite au moins une décision passée.

## Métriques de succès

- Taux d'adoption des recommandations : > 40 % des suggestions acceptées par les PMs.
- Temps de décision moyen : réduction de 20 % en 8 semaines.

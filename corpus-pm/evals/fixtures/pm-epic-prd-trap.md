# Export CSV des décisions

## Problème

Les PMs ne peuvent pas extraire les décisions dans des outils externes (Excel, Notion,
Google Sheets). La seule façon d'exporter est une capture d'écran.

## Objectifs

Permettre l'export au format CSV de la liste des décisions filtrées.

## Hors périmètre

Export PDF non inclus en V1. Export API (JSON) non inclus en V1.

## User stories

- En tant que PM, je veux exporter la liste des décisions en CSV pour les analyser dans
  Excel lors de mes bilans trimestriels.

## Exigences

### P0 — Bouton d'export

Un bouton « Exporter en CSV » est disponible sur la vue liste des décisions.

### P0 — Colonnes exportées

Le CSV contient exactement 5 colonnes : titre, date, auteur, tags, statut.

## Critères d'acceptation

- P0 Bouton : visible et cliquable pour tout utilisateur authentifié sur la vue liste.
- P0 Colonnes : le CSV généré contient exactement les 5 colonnes spécifiées dans l'ordre
  titre, date, auteur, tags, statut.

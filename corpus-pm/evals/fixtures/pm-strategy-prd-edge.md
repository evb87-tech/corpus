# Recherche avancée dans le journal des décisions

## Problème

Les équipes produit ne retrouvent pas les décisions passées. Le temps de recherche
moyen est de 45 minutes par semaine par PM.

## Objectifs

Permettre la recherche plein texte et filtrée dans le journal des décisions.

## Hors périmètre

Recherche sémantique (IA) non incluse en V1.

## User stories

- En tant que PM, je veux chercher par mot-clé pour retrouver une décision en moins
  de 10 secondes.

## Exigences

### P0 — Barre de recherche plein texte

La barre de recherche indexe le titre et le corps de toutes les décisions.

### P1 — Filtres par date et par tag

L'utilisateur peut filtrer les résultats par plage de dates et par tag.

## Critères d'acceptation

- P0 : résultat affiché en < 1 s pour un corpus de 1 000 décisions.
- P1 : la combinaison filtre date + filtre tag retourne uniquement les décisions
  correspondant aux deux critères.

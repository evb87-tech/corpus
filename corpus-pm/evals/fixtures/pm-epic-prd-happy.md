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

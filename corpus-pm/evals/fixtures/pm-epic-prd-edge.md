# Commentaires collaboratifs sur les décisions

## Problème

Les décisions produit sont statiques une fois enregistrées. Les membres de l'équipe ne
peuvent pas ajouter de contexte, de réserves ou de mises à jour directement dans le
journal.

## Objectifs

Permettre la collaboration asynchrone autour des décisions via des commentaires.

## Hors périmètre

Pas de fil de discussion threadé (réponses aux commentaires) en V1.

## User stories

- En tant que membre de l'équipe, je veux commenter une décision pour ajouter du contexte
  sans modifier la décision elle-même.

## Exigences

### P0 — Ajout de commentaires

Un utilisateur authentifié peut ajouter un commentaire textuel à une décision.

### P1 — Mentions

Un utilisateur peut @mentionner un collègue dans un commentaire.

## Critères d'acceptation

- P0 Commentaires : le commentaire s'affiche sous la décision en < 500 ms après soumission.
- P1 Mentions : la @mention envoie une notification email dans < 1 min.

## Métriques de succès

- Améliorer la satisfaction utilisateur sur la collaboration.
- Augmenter l'engagement avec les décisions passées.

# Système de design tokens partagé

## Problème

L'équipe design et l'équipe engineering maintiennent deux versions désynchronisées des
composants visuels. Chaque sprint génère des incohérences de rendu entre les maquettes
et le produit livré.

## Objectifs

Établir une source unique de vérité pour les tokens de design (couleurs, typographie,
espacement, rayon de bord).

## Utilisateurs ciblés

- **Principal** : Alex, le designer produit — produit les maquettes et valide les
  implémentations.
- **Secondaire** : Marie, chef de produit — valide les livrables visuels avant release.

## User stories

- En tant que designer (Alex), je veux accéder aux tokens depuis Figma pour ne plus
  saisir manuellement les valeurs hexadécimales.
- En tant que PM (Marie), je veux que les maquettes et le produit livré soient cohérents
  pour réduire les itérations de validation.

## Exigences

### P0 — Bibliothèque de tokens

Un fichier de référence centralise tous les tokens et est versionné dans le dépôt.

### P1 — Plugin Figma

Un plugin Figma lit les tokens depuis le dépôt et les importe dans les styles Figma.

## Critères d'acceptation

- P0 : le fichier de tokens est lisible par les ingénieurs sans outillage supplémentaire.
- P1 : le plugin met à jour les styles Figma en < 30 s.

## Métriques de succès

- Réduction des incohérences visuelles signalées en review : - 80 % en 6 semaines.
- Temps de synchronisation design/dev : < 1 h par sprint (baseline : 4 h).

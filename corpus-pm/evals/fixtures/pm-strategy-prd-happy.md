# Onboarding mobile — V1

## Problème

Les nouveaux utilisateurs qui accèdent au produit depuis leur téléphone abandonnent le
parcours d'onboarding à 68 %. L'interface desktop n'est pas adaptée aux écrans mobiles.

## Objectifs

Réduire le taux d'abandon onboarding mobile à < 30 % en Q2 2026.

## Hors périmètre

Pas d'application native iOS/Android. Onboarding web responsive uniquement.

## User stories

- En tant que nouvel utilisateur mobile, je veux un onboarding adapté à mon écran pour
  ne pas être perdu dès la première connexion.

## Exigences

### P0 — Interface responsive pour l'onboarding

Les 5 écrans d'onboarding s'affichent correctement sur les résolutions 375px à 428px.

### P1 — Notifications push pour relancer l'onboarding abandonné

Un utilisateur qui abandonne l'onboarding reçoit une notification push 24 h après
l'abandon.

## Critères d'acceptation

- P0 : tous les boutons CTA sont cliquables avec un pouce en position naturelle (zone
  de confort thumb).
- P1 : la notification push est envoyée dans la fenêtre de 22 à 24 h après l'abandon.

## Métriques de succès

- Taux d'achèvement onboarding mobile : > 70 % en semaine 6 post-lancement.
- Taux d'abandon : < 30 % (baseline : 68 %).

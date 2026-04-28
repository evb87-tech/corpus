# Tableau de bord analytics pour PMs et CSMs

## Problème

Les PMs et les Customer Success Managers manquent de visibilité sur l'usage réel du
produit. Les données sont éparpillées dans plusieurs outils (Mixpanel, Salesforce, Jira)
et ne sont pas agrégées.

## Objectifs

Proposer un tableau de bord unifié donnant accès aux métriques clés d'usage et de santé
client en temps quasi-réel.

## Utilisateurs ciblés

- **Principal** : les PMs — pour le suivi des métriques produit.
- **Secondaire** : les CSMs — pour le suivi de la santé des comptes.

## User stories

- En tant que PM, je veux voir l'adoption feature par feature pour prioriser les
  investissements produit.
- En tant que CSM, je veux voir le score de santé de chaque compte pour anticiper le churn.

## Exigences

### P0 — Vue adoption par feature

Le tableau de bord affiche le taux d'adoption et le DAU/MAU pour chaque feature activée.

### P0 — Vue santé client

Le tableau de bord affiche un score de santé par compte (0–100) calculé à partir des
métriques d'usage, du NPS et du statut d'abonnement.

### P1 — Alertes automatiques

Une alerte est envoyée par email au CSM responsable quand le score de santé d'un compte
passe sous 40.

## Critères d'acceptation

- P0 Vue adoption : les données sont rafraîchies toutes les 15 minutes.
- P0 Vue santé : le score est recalculé quotidiennement à 6 h UTC.
- P1 Alertes : l'email est envoyé dans les 30 minutes suivant le passage sous le seuil.

## Métriques de succès

- Réduction du temps de préparation des business reviews : - 60 % en 4 semaines.
- Taux de churn détecté en avance (> 30 jours avant l'échéance) : + 25 %.

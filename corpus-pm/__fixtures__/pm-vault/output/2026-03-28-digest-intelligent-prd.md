---
type: prd
feature: digest-intelligent
date: 2026-03-28
status: draft
wiki-sources: [persona-sophie-em, persona-luc-devops, persona-camille-tech-lead, feature-digest-intelligent, decision-digest-opt-in-summarisation, competitor-alertflow, competitor-digestbot]
---

# PRD — Digest Intelligent

## Problème

Les équipes engineering reçoivent des centaines de notifications par jour dont la grande majorité ne nécessite pas d'action immédiate. Cette surcharge de notifications en temps réel génère des interruptions continues, une fatigue cognitive, et un coût d'onboarding élevé pour les nouveaux membres qui n'ont pas encore développé le modèle mental de triage (voir [[wiki/persona-sophie-em]], [[wiki/persona-luc-devops]]).

Les outils de digest existants (DigestBot) ne distinguent pas la sévérité des alertes — ils traitent un incident P1 et un message d'anniversaire avec le même niveau de priorité, ce qui aboutit à un rejet de l'outil (67 % d'abandon dans notre enquête, source [[wiki/persona-camille-tech-lead]]).

## Objectifs

- Réduire les interruptions liées aux notifications non critiques pour les utilisateurs actifs.
- Offrir aux engineering managers un digest configurable au niveau de la squad (pas seulement personnel).
- Différencier NotifAI sur la combinaison routage + digest, non couverte par AlertFlow ni DigestBot (voir [[wiki/competitor-alertflow]], [[wiki/competitor-digestbot]]).

## User stories

**En tant que Sophie (Engineering Manager)**, je veux configurer un digest de squad regroupant toutes les notifications non critiques pendant les heures de travail, afin que mon équipe puisse se concentrer sur les incidents réels sans être submergée par le bruit. ([[wiki/persona-sophie-em]])

**En tant que Luc (Head of DevOps)**, je veux définir moi-même le seuil de sévérité qui envoie une notification dans le digest plutôt qu'en temps réel, via une règle que je peux lire et modifier, afin de ne pas déléguer cette décision à un modèle IA. ([[wiki/persona-luc-devops]])

**En tant que Camille (Tech Lead)**, je veux que les notifications GitHub et Linear sous mon seuil personnel atterrissent dans un digest Slack plutôt que de m'interrompre, afin de préserver mes blocs de travail profond. ([[wiki/persona-camille-tech-lead]])

## Exigences

### P0 — Fenêtres de digest configurables

L'utilisateur (ou l'admin squad) peut définir des fenêtres horaires de digest (ex : 9h00, 13h00, 17h30). En dehors de ces fenêtres, les notifications non critiques sont mises en file d'attente. À l'heure de la fenêtre, un digest est envoyé dans le canal Slack ou l'interface configurée.

Critères d'acceptation :
- L'utilisateur peut définir entre 1 et 4 fenêtres par jour.
- L'utilisateur peut définir des jours actifs (ex : lundi–vendredi uniquement).
- Le digest est envoyé dans les 5 minutes suivant l'heure configurée.

### P0 — Seuil de sévérité configurable par règle

L'utilisateur peut définir le seuil de sévérité en dessous duquel une notification est dirigée vers le digest plutôt qu'en temps réel. Ce seuil est exprimé sous forme de règle lisible par un humain (ex : "toutes les alertes de niveau INFO ou WARNING vont dans le digest").

Critères d'acceptation :
- L'utilisateur peut écrire une règle de seuil en langage simplifié (si/alors, avec les niveaux de sévérité de la source).
- La règle est affichée dans le log de routage pour chaque notification redirigée.
- L'utilisateur peut modifier la règle sans redémarrer le service.

### P0 — Bypass critique permanent

Les notifications classifiées P1 ou "critical" dans la source (PagerDuty, Datadog, OpsGenie) bypassent systématiquement le digest et sont livrées en temps réel, quelles que soient les règles de seuil configurées.

Critères d'acceptation :
- Un alerte P1 est livrée en temps réel même si l'utilisateur est en fenêtre de digest.
- Le log indique "bypass critique — livré en temps réel" pour ces alertes.

### P1 — Résumé IA du contenu du digest (opt-in)

Lorsque l'utilisateur active la summarisation IA (opt-in), les items du digest sont groupés thématiquement et un résumé de 2-3 phrases est généré pour chaque groupe. Lorsqu'elle est désactivée, les items du digest sont listés sans résumé.

Critères d'acceptation :
- La summarisation IA est désactivée par défaut (opt-in).
- L'utilisateur peut activer/désactiver la summarisation depuis les paramètres de digest.
- Lorsqu'elle est activée, chaque groupe dans le digest affiche : titre du groupe, résumé IA, liste des items individuels (dépliable).

### P1 — Digest au niveau squad (admin)

Un admin squad peut configurer un digest commun pour toute la squad, avec les mêmes règles de seuil et les mêmes fenêtres. Les membres individuels peuvent surcharger les règles squad pour leur propre compte.

### P2 — Log de routage par item de digest

Chaque item du digest est accompagné d'un log indiquant pourquoi il a été redirigé vers le digest : règle appliquée, sévérité détectée, heure de réception vs heure de fenêtre.

## Hors périmètre

- Digest cross-canaux (Teams, email) : uniquement Slack pour v1.
- Apprentissage automatique adaptatif du seuil : le seuil est défini manuellement par l'utilisateur. Aucun ML ne modifie les règles de seuil sans action de l'utilisateur.
- Rétention des données digest au-delà de 24h : les items du digest sont supprimés des serveurs NotifAI après 24h. (Contrainte légale identifiée par [[wiki/persona-marie-ciso]].)
- Interface de configuration visuelle (éditeur drag-and-drop) : les règles sont éditées en texte pour v1.

## Métriques de succès

- **Activation digest** : 55 % des équipes actives configurent au moins une fenêtre de digest dans les 30 premiers jours.
- **Volume de notifications temps réel** : réduction de 35 % du volume de notifications livrées en temps réel pour les utilisateurs avec digest activé (mesuré par télémétrie de livraison).
- **Taux de bypass critique** : moins de 2 % des alertes classifiées P1 sont dirigées vers le digest (indicateur de qualité de classification).
- **Rétention** : le taux de rétention à 60 jours des utilisateurs avec digest activé est supérieur de 12 points à celui des utilisateurs sans digest.
- **NPS différentiel** : le NPS des utilisateurs avec digest activé est supérieur de +10 points au NPS global.

## Risques identifiés

| Risque | Probabilité | Impact | Mitigation |
|---|---|---|---|
| Escalade de sévérité artificielle (tout marquer P1 pour bypasser le digest) | Moyenne | Élevé | Rate limiting + détection "boy who cried wolf" (P2) |
| Rejet du résumé IA (confiance faible) | Élevée | Moyen | Opt-in pour la summarisation — le digest fonctionne sans IA |
| Blocage RSSI sur la rétention des données digest | Faible-Moyenne | Élevé | Politique de rétention 24h + DPA disponible avant signature |
| Fragmentation UX entre mode règles (Luc) et mode squad (Sophie) | Moyenne | Moyen | Config unifiée avec hiérarchie squad > individuel |

## Questions ouvertes

1. L'opt-in pour la summarisation IA est assumé dans ce PRD (exigence P1) — mais aucun verbatim utilisateur ne tranche explicitement entre opt-in et opt-out. Voir [[wiki/decision-digest-opt-in-summarisation]] pour le contexte complet.
2. La fréquence minimum de digest acceptable n'est pas documentée dans les sources. Antoine suppose 2/jour sans donnée — à valider avant de coder le minimum configurable.
3. Comment le digest interagit-il avec la rotation d'astreinte ? La personne d'astreinte bypass-t-elle le digest pour toutes les notifications, ou uniquement pour les P1 ?

## Références wiki

- [[wiki/persona-sophie-em]] — persona principal
- [[wiki/persona-luc-devops]] — persona secondaire
- [[wiki/persona-camille-tech-lead]] — persona tertiaire
- [[wiki/persona-marie-ciso]] — gatekeeper légal et sécurité
- [[wiki/feature-digest-intelligent]] — page feature wiki
- [[wiki/decision-digest-opt-in-summarisation]] — décision liée
- [[wiki/competitor-alertflow]] — concurrent sans digest
- [[wiki/competitor-digestbot]] — concurrent sans sévérité

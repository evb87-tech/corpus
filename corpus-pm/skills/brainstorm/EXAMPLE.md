---
type: brainstorm
idea: "notifications push pour les utilisateurs mobiles inactifs depuis 7 jours"
date: 2026-04-28
status: draft
verdict: à affiner
wiki-sources: [positioning-produit-mobile, decision-no-push-q3-2025, persona-acheteur-recurrent, persona-visiteur-occasionnel, competitor-rival-alpha, competitor-rival-beta]
---

# Brainstorm — notifications push pour les utilisateurs mobiles inactifs depuis 7 jours

> Séance de pression-test conduite par /pm-brainstorm le 2026-04-28.
> Verdict : à affiner

---

## A — Alignement positionnement + décisions passées

**Sources lues :** `[[wiki/positioning-produit-mobile]]`, `[[wiki/decision-no-push-q3-2025]]`

La page `[[wiki/positioning-produit-mobile]]` déclare explicitement :

> « Notre différenciation repose sur l'absence de friction : pas d'interruptions non sollicitées, pas de notifications non actionnables. »

L'idée de notifications push pour les inactifs entre en tension directe avec ce positionnement. L'inactivité de 7 jours peut signifier un désengagement choisi plutôt qu'un oubli — envoyer une notification dans ce cas constitue une interruption non sollicitée au sens de la page de positionnement.

La page `[[wiki/decision-no-push-q3-2025]]` documente une décision explicite prise en Q3 2025 :

> « Alternatif écarté : notifications push de ré-engagement. Raison : taux de désinstallation élevé observé en test A/B sur cohorte août 2025. »

**Tension identifiée :** l'idée contredit une décision documentée avec données empiriques. L'idée nécessite soit une justification que les conditions ont changé, soit une définition plus précise des inactifs ciblés (segment opt-in explicite vs. inactifs génériques).

---

## B — Personas gagnants et perdants

**Sources lues :** `[[wiki/persona-acheteur-recurrent]]`, `[[wiki/persona-visiteur-occasionnel]]`

**Persona gagnant — Acheteur récurrent** `[[wiki/persona-acheteur-recurrent]]`

Champ `## Motivations` : « Ne pas manquer les promotions sur les catégories qu'il suit. »
Champ `## Frictions` : « Oublie de revenir consulter l'appli entre deux achats. »

L'idée adresse directement cette friction documentée. Un rappel après 7 jours d'inactivité répond au besoin de cet acheteur, à condition que la notification soit contextualisée (« Nouvelle promo sur vos catégories préférées ») et non générique.

**Persona perdant — Visiteur occasionnel** `[[wiki/persona-visiteur-ocasionnel]]`

Champ `## Frictions` : « Se sent harcelé par les apps qui envoient trop de notifications. Désinstalle rapidement. »
Champ `## Motivations` : « Consulte l'appli uniquement à l'initiative d'un besoin ponctuel. »

L'idée pénalise directement ce persona. Une notification push après 7 jours d'inactivité volontaire sera perçue comme du harcèlement selon la friction documentée, et risque de déclencher la désinstallation.

**Conflit non résolu :** les deux personas ont des besoins contradictoires vis-à-vis de l'idée. Le wiki ne documente pas de mécanisme de segmentation entre ces deux profils. L'idée doit être resserrée sur le persona acheteur récurrent uniquement, ou accompagnée d'un opt-in explicite qui exclut le visiteur occasionnel.

---

## C — Contexte concurrentiel et différenciation

**Sources lues :** `[[wiki/competitor-rival-alpha]]`, `[[wiki/competitor-rival-beta]]`

**Rival Alpha** `[[wiki/competitor-rival-alpha]]`

Champ `## Forces` : « Notifications push personnalisées avec taux d'ouverture documenté à 23% (last-observed : 2025-11-15). »
Champ `## Faiblesses` : « Segmentation grossière — envoie à tous les inactifs sans distinction de profil. »

Rival Alpha fait déjà ce que l'idée propose, mais mal : sans segmentation. Une version segmentée (acheteurs récurrents uniquement, opt-in explicite) pourrait se différencier.

**Rival Beta** `[[wiki/competitor-rival-beta]]`

Champ `## Forces` : « Ré-engagement par email uniquement — pas de push. Taux de désabonnement faible. »
Champ `## Faiblesses` : « Pas de canal mobile natif. »

Rival Beta a délibérément évité le push et opte pour l'email. Cela valide que la pression concurrentielle ne force pas à aller vers le push.

**Avertissement de fraîcheur :** `last-observed` de `[[wiki/competitor-rival-alpha]]` date de novembre 2025 (5 mois). Les données peuvent être partiellement périmées. Vérifier si Rival Alpha a affiné sa segmentation depuis.

**Différenciation possible :** une implémentation opt-in par segment (acheteurs récurrents uniquement) se différencie de Rival Alpha sur la précision, et comble le vide mobile de Rival Beta. Mais cette différenciation n'est pas documentée dans le wiki actuel — elle est une inférence à confirmer par le propriétaire.

---

## Verdict de séance

**Verdict : à affiner**

L'idée a un fondement réel pour le persona `[[wiki/persona-acheteur-recurrent]]` et un angle de différenciation vis-à-vis de `[[wiki/competitor-rival-alpha]]`. Mais deux obstacles documentés doivent être levés avant d'aller plus loin :

1. **Décision Q3 2025 :** `[[wiki/decision-no-push-q3-2025]]` documente un test A/B négatif. L'idée doit expliquer pourquoi les conditions sont différentes (segment plus précis, opt-in explicite, déclencheur différent).
2. **Fracture persona :** le persona `[[wiki/persona-visiteur-ocasionnel]]` sera pénalisé. L'idée doit être resserrée à un périmètre opt-in ou segmenté avant de valoir le développement.

L'idée n'est pas abandonnée — elle est sous-spécifiée. Resserrez sur le persona acheteur récurrent avec un opt-in explicite, et repassez la décision Q3 2025 en revue.

---

## Sources wiki

Pages consultées :
- `[[wiki/positioning-produit-mobile]]`
- `[[wiki/decision-no-push-q3-2025]]`
- `[[wiki/persona-acheteur-recurrent]]`
- `[[wiki/persona-visiteur-ocasionnel]]`
- `[[wiki/competitor-rival-alpha]]`
- `[[wiki/competitor-rival-beta]]`

Lacunes signalées :
- segment-* : aucune page de segment consultée (non pertinent pour cet exemple)
- feature-* : aucune fonctionnalité connexe documentée dans le wiki pour ce sujet

---
type: persona
sources: [raw/interview-sophie-martin-2026-02.md, raw/persona-research-survey-2026-01.md]
last_updated: 2026-03-01
pains: [surcharge de notifications, manque de clarté pour les nouveaux membres, culpabilité de ne pas répondre immédiatement]
goals: [clarté pour toute l'équipe sur ce qui est urgent, auditabilité des décisions de routage, protection des données sensibles liées aux astreintes]
---

# Sophie — Engineering Manager (EM)

## Résumé

Sophie est engineering manager dans une scale-up santé de 200 personnes. Elle gère une squad de 8 ingénieurs et coordonne avec 3 autres squads. Elle souffre d'une surcharge de notifications quotidienne (80 à 200 messages non lus chaque matin) et a développé une expertise personnelle tacite pour trier l'urgent du bruit — expertise qu'elle ne peut pas transmettre facilement à son équipe.

## Ce que disent les sources

D'après raw/interview-sophie-martin-2026-02.md : Sophie retarde délibérément l'ouverture de Slack jusqu'à 9h30 pour éviter le mode pompier. Elle a mis en place des règles mentales claires (canal #on-call = urgent, #general = pas urgent) mais ces règles ne sont documentées nulle part. Les nouveaux membres de son équipe passent 3 mois avant d'acquérir ce même modèle mental.

D'après raw/interview-sophie-martin-2026-02.md : Sophie a testé un bot de résumé Slack. Le bot traitait un alerte d'incident et un message d'anniversaire au même niveau de priorité — elle a arrêté d'utiliser l'outil pour cette raison.

D'après raw/persona-research-survey-2026-01.md : Le segment "Orchestrator" (EM dans des orgs 100–500 personnes) identifie la clarté des notifications pour l'équipe comme douleur principale, et l'auditabilité comme critère d'achat. Budget outil : €500–2 000/mois, avec validation IT/sécurité requise.

D'après raw/persona-research-survey-2026-01.md : 29 % des répondants signalent que les données de disponibilité/astreinte sont un bloqueur légal. Sophie l'a mentionné spontanément dans l'entretien (conversation avec le service juridique 6 mois avant l'interview).

## Connexions

- [[wiki/interview-sophie-martin-2026-02]] : entretien source complet
- [[wiki/segment-orchestrateurs-em]] : segment auquel Sophie appartient
- [[wiki/feature-digest-intelligent]] : fonctionnalité ciblant directement ses douleurs
- [[wiki/persona-luc-devops]] : persona adjacent, valeurs divergentes sur l'automatisation

## Contradictions

Aucune contradiction inter-sources sur Sophie. En revanche, ses attentes implicites (acceptation d'un routage adaptatif) contrastent avec la position explicite de [[wiki/persona-luc-devops]] (rejet du ML au profit de règles explicites). Voir [[wiki/interview-luc-bernard-2026-03]] pour la source de cette tension.

## Questions ouvertes

- Dans quelles conditions Sophie accepterait-elle un outil de digest qui choisit pour elle ce qui est prioritaire dans le digest ?
- La validation juridique autour des données d'astreinte est-elle un bloqueur dur ou un délai négociable ?
- Comment transférer son expertise tacite de triage dans un produit sans qu'elle ait à tout re-documenter manuellement ?

## Profil

Engineering Manager, santé-tech scale-up, ~200 personnes, squad de 8 ingénieurs + coordination cross-squads. Outils actuels : Slack, Jira, PagerDuty, GitHub. Ancienneté dans le rôle : non précisé. France.

## Motivations

- Que son équipe ait la même clarté qu'elle sur l'urgence, sans 3 mois de ramp-up.
- Ne pas rater un vrai incident en ignorant les notifications tôt le matin.
- Avoir une trace lisible des décisions de routage pour répondre aux questions légales.

## Frictions

- 80 à 200 messages non lus chaque matin — impossible à traiter sans filtre mental.
- Outils de résumé qui n'ont pas de notion de sévérité — le bruit et le signal reçoivent le même traitement.
- Données d'astreinte sensibles (accommodements, congés médicaux) — toute automatisation est scrutée par le juridique.

## Verbatims

> "I open Slack and there's always somewhere between 80 and 200 unread messages. I've learned to just not look at it before 9:30 because if I do, I'm already in firefighting mode before the day starts."
> — raw/interview-sophie-martin-2026-02.md

> "New team members have no idea. They escalate everything or miss everything — there's no middle ground for the first three months."
> — raw/interview-sophie-martin-2026-02.md

> "Auditability. I need to see a log: this alert came in, it was classified as P1, it was routed to Jean because he's on-call this week. If I can see that reasoning, I trust it. If it's a black box — no."
> — raw/interview-sophie-martin-2026-02.md

> "Anything that touches who gets woken up at 2am is sensitive. People have accommodations, stress leave, all sorts. A system that doesn't respect that... that's an HR issue, not just a product issue."
> — raw/interview-sophie-martin-2026-02.md

## Sources

- [[raw/interview-sophie-martin-2026-02.md]]
- [[raw/persona-research-survey-2026-01.md]]

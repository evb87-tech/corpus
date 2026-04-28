---
type: interview
sources: [raw/interview-sophie-martin-2026-02.md]
last_updated: 2026-03-01
interview-date: 2026-02-14
---

# Entretien — Sophie Martin, Engineering Manager, février 2026

## Résumé

Entretien de 55 minutes sur la gestion des notifications dans une squad d'ingénieurs. Sophie décrit une expertise tacite de triage qu'elle ne peut pas transférer à son équipe, un rejet des outils de résumé IA sans conscience de la sévérité, et des préoccupations légales concrètes autour des données d'astreinte. Elle accepte implicitement un routage adaptatif sous condition d'auditabilité explicite.

## Ce que disent les sources

D'après raw/interview-sophie-martin-2026-02.md : Sophie retarde l'ouverture de Slack jusqu'à 9h30. Elle a développé des règles mentales claires (canal par canal) mais elles ne sont documentées nulle part et prennent 3 mois à acquérir pour les nouveaux membres.

D'après raw/interview-sophie-martin-2026-02.md : Sophie a testé un bot de résumé Slack. La raison d'abandon : le bot traitait les alertes d'incident et les messages d'anniversaire au même niveau de priorité. Elle ne demande pas un outil sans IA — elle demande un outil qui comprend le contexte de sévérité.

D'après raw/interview-sophie-martin-2026-02.md : Sa demande clé si un outil pouvait faire une chose parfaitement : "Route the right notification to the right person at the right time." Elle ne demande pas de dashboard ni d'analytics.

D'après raw/interview-sophie-martin-2026-02.md : L'auditabilité est exprimée comme un prérequis de confiance — non une fonctionnalité bonus. Elle décrit un log de routage idéal avec : alerte reçue, classification, destinataire, raison.

D'après raw/interview-sophie-martin-2026-02.md : Les données d'astreinte (qui est réveillé à 2h du matin) sont qualifiées de données RH sensibles, non de simples données opérationnelles. Le service juridique a déjà été consulté.

## Connexions

- [[wiki/persona-sophie-em]] : fiche persona construite depuis cet entretien
- [[wiki/segment-orchestrateurs-em]] : segment auquel Sophie appartient
- [[wiki/persona-luc-devops]] : position divergente sur l'adaptatif vs règles explicites

## Contradictions

**Contradiction avec [[wiki/interview-luc-bernard-2026-03]] (contradiction exercice contradictor) :**

Sophie accepte implicitement un routage adaptatif, c'est-à-dire un système qui prend des décisions de routage sans que chaque règle soit écrite manuellement — sous condition que le log soit auditable. Elle n'exprime pas d'hostilité au ML.

Luc Bernard (raw/interview-luc-bernard-2026-03.md) refuse explicitement tout apprentissage automatique, même avec un log auditable. Pour lui, les règles doivent être écrites par un humain : "Rules are auditable. Learning is a black box."

Ces deux positions sont incompatibles : un produit qui adapte son routage automatiquement satisfera Sophie mais sera refusé par Luc. Un produit purement basé sur des règles manuelles satisfera Luc mais manquera la proposition de valeur "temps de ramp-up réduit" pour Sophie.

Sources directes de la contradiction :
- raw/interview-sophie-martin-2026-02.md : acceptation implicite de l'adaptatif (pas de règles manuelles mentionnées comme nécessaires)
- raw/interview-luc-bernard-2026-03.md : "I don't want AI that learns from my behavior. I want AI that follows my rules."

## Questions ouvertes

- Peut-on concevoir un produit qui offre les deux modes (règles manuelles ET apprentissage adaptatif) sans incohérence UX ?
- Sophie accepterait-elle un mode "règles par défaut, adaptatif optionnel" ou veut-elle l'adaptatif par défaut ?
- La préoccupation légale sur les données d'astreinte bloque-t-elle l'achat ou retarde-t-il seulement la décision ?

## Date

2026-02-14

## Profil interviewé

Sophie Martin, Engineering Manager, santé-tech scale-up ~200 personnes. Squad de 8 ingénieurs, coordination de 3 autres squads. Outils : Slack, Jira, PagerDuty, GitHub. France.

## Verbatims

> "I open Slack and there's always somewhere between 80 and 200 unread messages. I've learned to just not look at it before 9:30 because if I do, I'm already in firefighting mode before the day starts. But I feel guilty about that — what if there's a real incident?"
> — raw/interview-sophie-martin-2026-02.md

> "New team members have no idea. They escalate everything or miss everything — there's no middle ground for the first three months."
> — raw/interview-sophie-martin-2026-02.md

> "Route the right notification to the right person at the right time. That's it. I don't need a dashboard. I don't need analytics."
> — raw/interview-sophie-martin-2026-02.md

> "Auditability. I need to see a log: this alert came in, it was classified as P1, it was routed to Jean because he's on-call this week. If I can see that reasoning, I trust it. If it's a black box — no."
> — raw/interview-sophie-martin-2026-02.md

## Insights

1. L'auditabilité est un prérequis de confiance, pas une fonctionnalité différenciante — sa présence est nécessaire mais non suffisante.
2. Le vrai problème de Sophie n'est pas sa propre surcharge de notifications : c'est le coût d'onboarding de son expertise tacite. Un outil qui capture et applique cette expertise aurait une valeur plus grande qu'un simple filtre personnel.
3. Les données d'astreinte sont une zone légale à risque — elle doit être traitée comme telle dans le produit (minimisation des données, logs éphémères, documentation de conformité).

## Sources

- [[raw/interview-sophie-martin-2026-02.md]]

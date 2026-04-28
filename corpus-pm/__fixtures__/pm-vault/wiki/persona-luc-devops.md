---
type: persona
sources: [raw/interview-luc-bernard-2026-03.md, raw/persona-research-survey-2026-01.md]
last_updated: 2026-03-10
pains: [rapport bruit/signal catastrophique (285/300 alertes sont du bruit), expérience négative avec un outil ML, dépendance au RSSI pour tout achat outil]
goals: [contrôle explicite des règles de routage, auditabilité complète, tarification prévisible]
---

# Luc — Head of DevOps

## Résumé

Luc est responsable DevOps dans une scale-up logistique de 60 personnes. Il traite environ 300 alertes par jour dont 285 sont du bruit. Il a une expérience négative directe avec un outil de ML ops qui a appris de ses rejets et supprimé des alertes importantes — il a dû le rollback au bout de deux semaines. Il exige désormais des règles explicites, auditables et non-apprenantes pour tout outil de routage.

## Ce que disent les sources

D'après raw/interview-luc-bernard-2026-03.md : Luc reçoit ~300 alertes/jour, dont ~285 sont du bruit. Le contexte qui permet de distinguer les 15 importantes est dans sa tête : jour de la semaine, feature flags actifs, disponibilité de l'assigné. Aucun outil ne l'a capturé à ce jour.

D'après raw/interview-luc-bernard-2026-03.md : Luc a testé un outil ML ops "big vendor" l'an passé. L'outil a sur-appris de ses rejets et commencé à supprimer des alertes réellement importantes. Il l'a rollback après deux semaines. Cette expérience est le filtre à travers lequel il évalue tout nouvel outil.

D'après raw/interview-luc-bernard-2026-03.md : Luc veut "un moteur de règles en langage naturel qui explique ce qu'il a fait." Il cite comme valeur déterminante l'opposé de ce qu'il a vécu : règles vs apprentissage, explicable vs boîte noire.

D'après raw/persona-research-survey-2026-01.md : Le segment "Firefighter" (DevOps/SRE, 15–100 personnes) priorise la suppression du bruit et les règles explicites. Budget : €200–800/mois. Décideur : lui-même ou son manager direct.

## Connexions

- [[wiki/interview-luc-bernard-2026-03]] : entretien source complet
- [[wiki/segment-firefighters-devops]] : segment auquel Luc appartient
- [[wiki/feature-digest-intelligent]] : fonctionnalité pertinente mais avec des conditions fortes (règles, pas ML)
- [[wiki/persona-sophie-em]] : persona adjacent avec des attentes divergentes sur l'automatisation adaptative

## Contradictions

**Contradiction centrale avec [[wiki/persona-sophie-em]] :** Sophie accepte implicitement qu'un outil de routage adaptatif fasse des choix pour elle, sous condition d'auditabilité. Luc refuse explicitement tout apprentissage automatique, même auditable — il veut des règles qu'il a lui-même définies. Ces deux personas ont le même besoin de fond (bonne alerte, bon destinataire, bonne heure) mais des prérequis architecturaux incompatibles.

Sources : raw/interview-sophie-martin-2026-02.md (acceptation de l'adaptatif) vs raw/interview-luc-bernard-2026-03.md ("I don't want AI that learns from my behavior").

## Questions ouvertes

- Un moteur de règles en langage naturel satisfait-il Luc si les règles sont compilées en logique déterministe (pas de ML) ?
- Le RSSI de LogiTrack est-il un pattern courant dans le segment Firefighter ou spécifique à la logistique ?
- Luc serait-il prêt à payer €500/mois flat comme il l'indique — ou c'est une ancre de négociation ?

## Profil

Head of DevOps, SaaS logistique, ~60 personnes, gère l'infra pour une plateforme traitant ~4M événements/jour. Outils actuels : Zapier, PagerDuty (custom workflows). France. RSSI présent dans le processus d'achat.

## Motivations

- Réduire les 285 alertes bruyantes sans risquer de rater les 15 qui comptent.
- Garder le contrôle total sur les règles de classification.
- Pouvoir expliquer chaque décision de l'outil à son RSSI.

## Frictions

- Les outils ML apprennent trop vite et sur-suppriment — vécu négatif direct.
- Le contexte discriminant (feature flags, week-end, disponibilité) est dans sa tête, pas dans les données.
- L'achat de tout outil passe par la validation du RSSI, qui priorise la souveraineté des données.

## Verbatims

> "I get maybe 300 alerts a day. 285 of them are noise. The problem is I can't automate the suppression because the 15 that matter look almost identical to the 285 that don't — until you know the context."
> — raw/interview-luc-bernard-2026-03.md

> "I don't want AI that learns from my behavior. I want AI that follows my rules. There's a big difference. Rules are auditable. Learning is a black box."
> — raw/interview-luc-bernard-2026-03.md

> "Give me a rule engine that I can write in plain English and that explains what it did. Like: 'This alert was suppressed because it matched rule: service=payments AND error_rate<0.1% AND time=business-hours.' I'd pay for that tomorrow."
> — raw/interview-luc-bernard-2026-03.md

> "I've been burned by 'startup pricing' that tripled after Series B. I'd pay €500/month flat if the product does what it says."
> — raw/interview-luc-bernard-2026-03.md

## Sources

- [[raw/interview-luc-bernard-2026-03.md]]
- [[raw/persona-research-survey-2026-01.md]]

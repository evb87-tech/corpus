---
type: interview
sources: [raw/interview-luc-bernard-2026-03.md]
last_updated: 2026-03-10
interview-date: 2026-03-05
---

# Entretien — Luc Bernard, Head of DevOps, mars 2026

## Résumé

Entretien de 40 minutes (notes uniquement, enregistrement refusé). Luc a une expérience négative directe avec un outil ML ops qui a sur-appris de ses rejets et supprimé des alertes importantes. Cette expérience structure tout son cadre d'évaluation : il ne veut pas d'apprentissage automatique, il veut des règles explicites en langage naturel avec explication de chaque décision. Il accepterait un prix fixe de €500/mois mais son RSSI est un gatekeeper non négociable.

## Ce que disent les sources

D'après raw/interview-luc-bernard-2026-03.md : Le contexte discriminant qui permet de distinguer les 15 alertes importantes des 285 bruyantes est entièrement dans la tête de Luc. Il dépend de variables qui ne sont pas dans les données d'alerte : jour/heure, feature flags, disponibilité de l'assigné.

D'après raw/interview-luc-bernard-2026-03.md : Luc a utilisé un "big vendor AI ops tool" l'an passé. L'outil a sur-appris de ses rejets manuels et commencé à supprimer des alertes réellement importantes. Rollback après deux semaines. Il parle de cet épisode comme d'une perte de confiance irréversible dans les outils ML pour ce cas d'usage.

D'après raw/interview-luc-bernard-2026-03.md : Sa formulation exacte de ce qu'il veut — "un moteur de règles que je peux écrire en langage naturel et qui explique ce qu'il a fait" — est précise et réitérée. Ce n'est pas une préférence : c'est une condition sine qua non.

D'après raw/interview-luc-bernard-2026-03.md : Son équipe suivrait n'importe quel outil qu'il choisit (pas de résistance interne). Le seul gatekeeper est le RSSI, qui pose systématiquement deux questions : résidence des données, droits d'accès.

D'après raw/interview-luc-bernard-2026-03.md : Prix cible de Luc : €500/mois flat. Il a été brûlé par une tarification startup qui a triplé post-Series B.

## Connexions

- [[wiki/persona-luc-devops]] : fiche persona construite depuis cet entretien
- [[wiki/segment-firefighters-devops]] : segment auquel Luc appartient
- [[wiki/persona-marie-ciso]] : profil du gatekeeper RSSI mentionné par Luc
- [[wiki/interview-sophie-martin-2026-02]] : entretien avec position divergente sur ML vs règles

## Contradictions

**Contradiction centrale avec [[wiki/interview-sophie-martin-2026-02]] :**

Luc exige des règles écrites par un humain, explicitement opposées au ML. Il a vécu un échec ML direct. Sa position est : "Rules are auditable. Learning is a black box."

Sophie (raw/interview-sophie-martin-2026-02.md) n'a pas exprimé d'exigence de règles manuelles. Elle accepte implicitement qu'un système fasse des choix de routage pour elle, sous condition que le log soit lisible. Elle n'a pas mentionné les règles manuelles comme nécessaires.

Cette contradiction est non réconciliable sans segmentation produit : un mode "règles explicites" pour Luc, un mode "adaptatif auditable" pour Sophie — ou un produit qui se positionne sur l'un des deux segments seulement.

## Questions ouvertes

- Le "big vendor" ML ops que Luc a testé : est-ce AlertFlow, un autre concurrent, ou un produit différent (OpsGenie, PagerDuty ML features) ? Le nom n'est pas mentionné.
- Les règles en "langage naturel" que Luc veut : s'attend-il à du NLP (il tape en prose) ou à un DSL simplifié (if/then) ? La distinction est architecturale.
- €500/mois flat : comment Luc positionne-t-il cela par rapport à un prix par utilisateur ?

## Date

2026-03-05

## Profil interviewé

Luc Bernard, Head of DevOps, SaaS logistique ~60 personnes. Infra traitant ~4M événements/jour. Outils : Zapier, PagerDuty (workflows custom). France. Référé par réseau commun.

## Verbatims

> "I get maybe 300 alerts a day. 285 of them are noise. The problem is I can't automate the suppression because the 15 that matter look almost identical to the 285 that don't — until you know the context."
> — raw/interview-luc-bernard-2026-03.md

> "I tried one of those AI ops tools last year. Big vendor, big price. It made things worse. It learned from my dismissals and started suppressing alerts that were actually important. I had to roll it back after two weeks."
> — raw/interview-luc-bernard-2026-03.md

> "I don't want AI that learns from my behavior. I want AI that follows my rules. There's a big difference. Rules are auditable. Learning is a black box."
> — raw/interview-luc-bernard-2026-03.md

> "Give me a rule engine that I can write in plain English and that explains what it did."
> — raw/interview-luc-bernard-2026-03.md

## Insights

1. L'expérience ML négative de Luc est un filtre cognitif puissant — ce n'est pas une préférence théorique, c'est une réaction à un échec vécu. Un framing "règles + IA optionnelle" risque de ne pas le convaincre si "IA" apparaît dans le pitch.
2. La formulation "rule engine in plain English" est un signal produit précis : la valeur est dans la lisibilité des règles pour un humain, pas dans leur puissance expressive.
3. Le RSSI comme gatekeeper est un pattern de go-to-market, pas seulement un persona : il faut des assets de vente pré-construits pour ce profil (DPA, résidence des données, audit trail).

## Sources

- [[raw/interview-luc-bernard-2026-03.md]]

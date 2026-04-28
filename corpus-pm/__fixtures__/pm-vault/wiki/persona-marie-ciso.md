---
type: persona
sources: [raw/interview-sophie-martin-2026-02.md, raw/interview-luc-bernard-2026-03.md, raw/persona-research-survey-2026-01.md]
last_updated: 2026-03-10
pains: [outils tiers traitant des données de disponibilité et d'astreinte sans revue légale, manque de visibilité sur ce que font les outils avec les données RH]
goals: [valider que tout outil de routage respecte la réglementation sur les données personnelles, contrôle sur où vont les données d'astreinte et de disponibilité]
---

# Marie — RSSI / DPO (persona bloqueur)

## Résumé

Marie n'est pas utilisatrice directe du produit — elle est le gatekeeper légal et sécurité dans le processus d'achat de Luc et potentiellement de Sophie. Elle représente la préoccupation de conformité qui apparaît spontanément dans deux entretiens indépendants et dans 29 % des répondants à l'enquête. Sa validation est un prérequis à l'achat pour une fraction significative de notre marché cible.

## Ce que disent les sources

D'après raw/interview-sophie-martin-2026-02.md : Sophie mentionne une "conversation avec notre service juridique il y a six mois" sur le fait que les données d'astreinte touchent aux accommodements et aux congés médicaux — c'est un sujet RH, pas seulement produit.

D'après raw/interview-luc-bernard-2026-03.md : Le RSSI de Luc pose systématiquement deux questions : "où vont les données, et qui peut les voir." C'est le premier filtre de tout achat outil chez LogiTrack.

D'après raw/persona-research-survey-2026-01.md : 29 % des répondants citent les "privacy concerns" comme raison d'abandon d'un outil de digest. Parmi les décideurs (n=31), 83 % citent l'auditabilité comme critère d'achat — partiellement corrélé à la conformité.

## Connexions

- [[wiki/persona-luc-devops]] : Luc doit obtenir la validation de son RSSI pour tout achat
- [[wiki/persona-sophie-em]] : Sophie a déjà consulté son juridique sur ce sujet
- [[wiki/decision-digest-opt-in-summarisation]] : la décision sur l'opt-in a des implications légales directes
- [[wiki/feature-digest-intelligent]] : la rétention des données digest (24h max selon Antoine) est un paramètre de conformité

## Contradictions

Aucune contradiction inter-sources. Le signal est cohérent sur deux entretiens indépendants et l'enquête : les données d'astreinte/disponibilité sont sensibles et exigent une revue légale.

## Questions ouvertes

- Quels sont exactement les articles RGPD ou conventions collectives qui s'appliquent aux données de disponibilité d'astreinte en France ?
- La rétention 24h des données digest (proposition d'Antoine dans raw/stakeholder-prd-draft-digest-v0.md) est-elle suffisante pour satisfaire un RSSI type ?
- Y a-t-il un marché pour une certification ou un rapport de conformité produit qui rende l'achat pré-approuvé chez les entreprises avec RSSI fort ?

## Profil

RSSI ou DPO dans des entreprises B2B tech de 30 à 500 personnes. N'utilise pas le produit. Intervient dans le cycle de vente comme validateur ou bloqueur. Critères : résidence des données, durée de rétention, droits d'accès, audit trail.

## Motivations

- Éviter tout incident de conformité RGPD lié à des données de disponibilité ou d'astreinte.
- Pouvoir répondre "oui, cet outil est conforme" sans avoir à faire un audit complet à chaque renouvellement.

## Frictions

- Les outils SaaS ne fournissent pas spontanément les informations de résidence des données et de rétention dans leur documentation publique.
- Les "privacy by design" claims des vendors sont souvent vagues.

## Verbatims

> "Anything that touches who gets woken up at 2am is sensitive. People have accommodations, stress leave, all sorts. A system that doesn't respect that... that's an HR issue, not just a product issue."
> — Sophie Martin, raw/interview-sophie-martin-2026-02.md

> "My CISO's first question is always: where does the data go, and who can see it."
> — Luc Bernard, raw/interview-luc-bernard-2026-03.md

## Sources

- [[raw/interview-sophie-martin-2026-02.md]]
- [[raw/interview-luc-bernard-2026-03.md]]
- [[raw/persona-research-survey-2026-01.md]]

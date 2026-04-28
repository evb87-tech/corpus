---
type: segment
sources: [raw/persona-research-survey-2026-01.md, raw/interview-luc-bernard-2026-03.md]
last_updated: 2026-03-10
---

# Segment — Firefighters (DevOps / SRE Leads)

## Résumé

Les Firefighters sont des responsables DevOps ou SRE dans des organisations B2B de 15 à 100 personnes. Leur douleur principale est le rapport signal/bruit des alertes : ils reçoivent des centaines d'alertes par jour dont la grande majorité est du bruit. Ils veulent contrôler explicitement les règles de classification, pas déléguer ce contrôle à un modèle ML.

## Ce que disent les sources

D'après raw/persona-research-survey-2026-01.md : Ce segment représente 28 répondants sur 87. Douleur principale : alerte fatigue, suppression du bruit. Critère d'achat : règles explicites (pas ML). Budget : €200–800/mois. Décideur : eux-mêmes ou leur manager direct.

D'après raw/interview-luc-bernard-2026-03.md : Luc illustre le pattern : 300 alertes/jour dont 285 du bruit, contexte discriminant dans sa tête, expérience négative avec un outil ML qui a sur-appris. Il veut un moteur de règles en langage naturel avec explication de chaque décision.

D'après raw/interview-luc-bernard-2026-03.md : La présence d'un RSSI dans le processus d'achat varie selon la taille de l'organisation. Pour LogiTrack (60 personnes), le RSSI intervient systématiquement.

## Connexions

- [[wiki/persona-luc-devops]] : persona représentatif du segment
- [[wiki/persona-marie-ciso]] : gatekeeper potentiel selon la taille de l'org
- [[wiki/competitor-alertflow]] : concurrent direct sur ce segment
- [[wiki/feature-digest-intelligent]] : fonctionnalité pertinente uniquement si règles > ML

## Contradictions

**Tension avec le segment Orchestrateurs :** Le segment Firefighters exige des règles explicites sans apprentissage automatique. Le segment Orchestrateurs (voir [[wiki/segment-orchestrateurs-em]]) est plus ouvert à un routage adaptatif sous condition d'auditabilité. Une fonctionnalité qui satisfait les deux segments simultanément est difficile à concevoir sans paramétrage par segment.

Sources : raw/interview-luc-bernard-2026-03.md ("I don't want AI that learns") vs raw/interview-sophie-martin-2026-02.md (acceptation implicite de l'adaptatif).

## Questions ouvertes

- La segmentation Firefighter/Orchestrateur est-elle suffisamment nette pour justifier des UX distinctes, ou faut-il un paramètre global "mode règles vs mode adaptatif" ?
- Le RSSI est-il systématique dans le segment Firefighter ou uniquement dans les orgs avec infra critique ?

## Définition

DevOps leads, SRE leads, ou responsables infrastructure dans des organisations B2B de 15 à 100 personnes. Gèrent des pipelines d'alertes (PagerDuty, Datadog, OpsGenie). Responsables de la disponibilité de services critiques.

## Critères

- Rôle : Head of DevOps, SRE Lead, Platform Engineer (senior)
- Taille org : 15–100 personnes
- Douleur : alerte fatigue, rapport signal/bruit
- Critère achat : règles explicites, pas ML, auditabilité
- Budget : €200–800/mois

## Taille estimée

Non chiffrée dans les sources. 28 répondants dans l'enquête.

## Personas associés

- [[wiki/persona-luc-devops]] — persona représentatif

## Sources

- [[raw/persona-research-survey-2026-01.md]]
- [[raw/interview-luc-bernard-2026-03.md]]

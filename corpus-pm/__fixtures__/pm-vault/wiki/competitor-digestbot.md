---
type: competitor
sources: [raw/competitor-scan-2026-01.md]
last_updated: 2026-03-01
last-observed: 2026-01-20
---

# DigestBot

## Résumé

DigestBot est un concurrent indirect — il couvre le digest Slack mais pas le routage d'incidents, et sans notion de sévérité. Sa faiblesse principale (résumés sans conscience de priorité) est exactement ce que nos personas identifient comme raison d'abandon. Il est positionné sur le segment marketing/comms, pas engineering. Son modèle freemium lui donne une forte présence en SMB.

## Ce que disent les sources

D'après raw/competitor-scan-2026-01.md : DigestBot est fondé en 2019, basé à Paris. Tarification freemium : gratuit jusqu'à 3 canaux, €79/mois/workspace, €249/mois/workspace (pro). Plus de 3 400 entreprises clientes selon LinkedIn.

D'après raw/competitor-scan-2026-01.md : DigestBot n'est pas construit pour les équipes engineering. Il ne distingue pas la sévérité des alertes — un message d'incident et un message de félicitations reçoivent le même traitement dans le digest.

D'après raw/competitor-scan-2026-01.md : Les avis G2 mentionnent "great for async comms, useless for incident management" et "would love a way to mark certain channels as 'always urgent.'" Ces avis confirment l'absence de gestion de sévérité comme lacune identifiée par les utilisateurs eux-mêmes.

D'après raw/competitor-scan-2026-01.md : DigestBot n'a pas d'API pour intégration custom — écosystème fermé. Pas d'auditabilité : l'utilisateur ne peut pas voir pourquoi un message a été inclus ou exclu d'un digest.

## Connexions

- [[wiki/segment-builders-ic]] : DigestBot adresse partiellement ce segment (sans sévérité)
- [[wiki/competitor-alertflow]] : concurrent sur la dimension routage (complémentaire à DigestBot)
- [[wiki/feature-digest-intelligent]] : fonctionnalité qui comble la lacune principale de DigestBot (sévérité)

## Contradictions

Aucune contradiction inter-sources sur DigestBot (une seule source).

## Questions ouvertes

- DigestBot a-t-il des projets pour intégrer une notion de sévérité dans ses digests ? [non documenté]
- Le modèle freemium crée-t-il un risque de comparaison défavorable pour NotifAI sur le prix d'entrée ?
- Les 3 400 installations LinkedIn sont-elles des installations actives ou des workspaces abandonnés ?

## Positionnement

"Your Slack notifications, finally under control." Ciblage : équipes Slack en général, avec un succès dans les segments marketing, comms, et RH. Pas de positionnement engineering.

## Forces

- Modèle freemium : faible friction d'acquisition, forte présence en SMB.
- UX Slack-native : setup en quelques minutes.
- NPS fort dans les équipes non-engineering (marketing, comms).

## Faiblesses

- Aucune notion de sévérité : bruit et signal traités identiquement.
- Pas de routage : résume uniquement, ne redirige pas les alertes.
- Pas d'API : intégration custom impossible.
- Pas d'auditabilité : l'utilisateur ne peut pas voir la logique d'inclusion.
- Fermé à l'engineering-grade : explicitement inadapté à la gestion d'incidents.

## Last observed

2026-01-20 (source : raw/competitor-scan-2026-01.md)

## Sources

- [[raw/competitor-scan-2026-01.md]]

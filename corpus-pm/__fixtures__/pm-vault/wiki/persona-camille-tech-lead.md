---
type: persona
sources: [raw/persona-research-survey-2026-01.md]
last_updated: 2026-03-01
pains: [interruptions pendant le travail profond, notifications hors contexte de ses projets, outils non intégrés à son workflow GitHub/Linear]
goals: [préserver des blocs de travail ininterrompus, recevoir uniquement les notifications qui nécessitent une action de sa part, intégration légère sans changer ses outils]
---

# Camille — Tech Lead / Senior IC

## Résumé

Camille est tech lead dans une startup de 35 personnes. Elle représente le segment "Builder" : des seniors ICs qui subissent les notifications comme une interruption de leur travail profond, non comme un problème de coordination d'équipe. Son budget est limité (budget personnel ou budget d'équipe €50–200/mois) et sa décision d'achat est autonome — elle n'a pas besoin de valider avec un RSSI ou un VP.

## Ce que disent les sources

D'après raw/persona-research-survey-2026-01.md : Le segment "Builder" (n=25 dans l'enquête) priorise la préservation du focus. Les ICs reçoivent des notifications provenant de dizaines de canaux dont la majorité ne les concernent pas directement — Slack de l'entreprise, GitHub PRs de toute l'équipe, Linear tickets.

D'après raw/persona-research-survey-2026-01.md : Ce segment a le budget le plus limité (€50–200/mois) mais la décision d'achat la plus autonome. Le critère d'intégration ("fonctionne avec mon stack : Slack, Linear, GitHub") est déterminant — les outils qui ajoutent une interface sont rejetés.

D'après raw/persona-research-survey-2026-01.md : 41 % de ce segment a essayé un outil de digest IA. 67 % ont arrêté. Raison principale (58 %) : l'outil traite le bruit et le signal au même niveau.

## Connexions

- [[wiki/segment-builders-ic]] : segment auquel Camille appartient
- [[wiki/feature-digest-intelligent]] : fonctionnalité potentiellement pertinente mais uniquement si intégrée nativement à Slack/Linear/GitHub
- [[wiki/persona-sophie-em]] : perspective manager, douleurs complémentaires mais différentes
- [[wiki/persona-luc-devops]] : préoccupations partiellement communes (signal/bruit) mais contexte très différent (infra vs. développement produit)

## Contradictions

Aucune contradiction inter-sources sur Camille. Le segment Builder est moins documenté que les segments EM et DevOps dans nos sources — une seule source (enquête) sans entretien individuel de suivi.

## Questions ouvertes

- Camille utiliserait-elle une fonctionnalité de digest si elle peut être configurée par GitHub labels ou Linear priorities (intégration native) plutôt que par un paramétrage séparé ?
- Quel est le seuil de tolérance pour une interface de configuration — zéro config vs. une fois au départ ?
- Le budget Builder (€50–200/mois) est-il compatible avec notre structure de prix cible ?

## Profil

Tech lead, startup produit, ~35 personnes. Outils : Slack, Linear, GitHub, Figma. Décision d'achat autonome. France ou Europe occidentale (enquête).

## Motivations

- Travailler en profondeur sans être interrompue par des notifications non actionnables.
- Recevoir uniquement les notifications qui attendent une action de sa part (review demandée, mention directe, blocage).
- Ne pas apprendre un nouvel outil — le filtre doit fonctionner dans Slack ou Linear.

## Frictions

- Les bots de résumé qu'elle a testés n'ont pas de notion de contexte — un commentaire GitHub sur un PR qu'elle ne touche pas reçoit le même traitement qu'une review demandée sur le sien.
- Les notifications non urgentes l'interrompent en milieu de bloc de travail profond.
- Budget limité : pas de budget "tool" propre dans sa startup, elle paye de sa poche ou négocie un budget d'équipe.

## Verbatims

Aucun verbatim direct disponible — persona construit depuis les données agrégées de l'enquête.

> "Summarized noise and signal equally."
> — IC anonyme, enquête raw/persona-research-survey-2026-01.md (raison d'abandon d'un outil de digest)

## Sources

- [[raw/persona-research-survey-2026-01.md]]

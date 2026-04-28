---
type: feature
sources: [raw/stakeholder-prd-draft-digest-v0.md, raw/interview-sophie-martin-2026-02.md, raw/interview-luc-bernard-2026-03.md, raw/persona-research-survey-2026-01.md]
last_updated: 2026-03-25
---

# Fonctionnalité — Digest intelligent

## Résumé

La fonctionnalité de digest intelligent vise à regrouper les notifications non critiques en résumés périodiques configurable par l'utilisateur, tout en laissant les alertes critiques passer en temps réel. Elle est demandée par des prospects enterprise comme prérequis à l'achat, et adresse la douleur de surcharge de notifications bas-priorité documentée dans deux entretiens et l'enquête. La tension centrale non résolue : segment Orchestrateur (Sophie) accepte un digest adaptatif ; segment Firefighter (Luc) exige des règles explicites.

## Ce que disent les sources

D'après raw/stakeholder-prd-draft-digest-v0.md : Antoine (VP Product) formule la proposition : fenêtres de digest configurables (ex : 9h, 13h, 17h), seuil de sévérité configurable, résumé IA des items groupés, bypass critique en temps réel.

D'après raw/interview-sophie-martin-2026-02.md : Sophie veut que les notifications non urgentes soient regroupées pour que son équipe puisse se concentrer. Elle a testé un bot de digest qui n'avait pas de notion de sévérité — raison d'abandon. Elle accepte un digest adaptatif sous condition d'auditabilité.

D'après raw/interview-luc-bernard-2026-03.md : Luc veut pouvoir définir lui-même le seuil de sévérité, pas le déléguer à un modèle. Son framing : "les règles que j'ai écrites décident ce qui va dans le digest, pas l'IA."

D'après raw/persona-research-survey-2026-01.md : 61 % des répondants citent le "smart routing" (bonne personne, bon moment) comme intervention la plus utile. Le digest est cité par 24 %. La combinaison routing + digest n'est pas dans les données enquête.

## Connexions

- [[wiki/persona-sophie-em]] : persona principal ciblé par la fonctionnalité
- [[wiki/persona-luc-devops]] : persona secondaire avec conditions fortes sur le contrôle des règles
- [[wiki/persona-camille-tech-lead]] : persona tertiaire (intégration Slack/Linear native requise)
- [[wiki/decision-digest-opt-in-summarisation]] : décision liée sur l'opt-in vs opt-out de la summarisation IA
- [[wiki/competitor-alertflow]] : concurrent sans digest — opportunité de différenciation
- [[wiki/competitor-digestbot]] : concurrent avec digest sans sévérité — lacune à combler

## Contradictions

**Contradiction architecturale entre personas :** Sophie accepte un digest adaptatif (le système décide ce qui est critique). Luc exige des règles manuelles (lui décide ce qui est critique). Un même moteur de digest ne peut pas satisfaire les deux sans un mode de configuration dual (règles vs. adaptatif). Voir [[wiki/interview-sophie-martin-2026-02]] et [[wiki/interview-luc-bernard-2026-03]] pour les sources primaires de cette tension.

**Assertion non sourcée d'Antoine :** raw/stakeholder-prd-draft-digest-v0.md affirme "I lean opt-in given our persona research" pour la summarisation IA. Cette assertion n'est tracée vers aucun verbatim des sources raw. Ni Sophie ni Luc n'ont exprimé de préférence explicite opt-in vs opt-out.

## Questions ouvertes

- Un mode "règles par défaut, adaptatif optionnel" résout-il la tension entre personas sans fragmenter le produit ?
- La summarisation IA est-elle opt-in ou opt-out ? [lacune : aucun verbatim utilisateur ne tranche]
- Quel est le seuil minimum de fréquence de digest acceptable ? [lacune : Antoine suppose 2/jour sans donnée]
- Comment le digest interagit-il avec la rotation d'astreinte — l'astreinte bypass-t-elle toujours le digest ?
- La rétention 24h des données digest (proposition Antoine) satisfait-elle le RSSI type ?

## Problème

Les utilisateurs reçoivent des notifications non critiques en temps réel, ce qui crée une surcharge cognitive et des interruptions continues. Les outils de digest existants (DigestBot) n'ont pas de notion de sévérité — ils regroupent le bruit et le signal de la même façon. Les utilisateurs abandonnent ces outils pour cette raison.

## Hypothèse de solution

Un digest configurable par sévérité (les items sous un seuil vont dans le digest, les items au-dessus passent en temps réel) avec une fenêtre horaire programmable. Les items dans le digest sont groupés thématiquement et résumés. Le log de routage reste accessible par item.

## Personas concernés

- [[wiki/persona-sophie-em]] — douleur principale (clarté équipe, digest niveau squad)
- [[wiki/persona-luc-devops]] — douleur compatible (réduction du bruit) mais conditions fortes (règles manuelles)
- [[wiki/persona-camille-tech-lead]] — douleur compatible (deep work préservé) mais budget et intégration native requise

## Décisions liées

- [[wiki/decision-digest-opt-in-summarisation]] : opt-in vs opt-out pour la summarisation IA

## Sources

- [[raw/stakeholder-prd-draft-digest-v0.md]]
- [[raw/interview-sophie-martin-2026-02.md]]
- [[raw/interview-luc-bernard-2026-03.md]]
- [[raw/persona-research-survey-2026-01.md]]

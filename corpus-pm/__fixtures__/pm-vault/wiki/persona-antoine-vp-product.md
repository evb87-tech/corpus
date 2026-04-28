---
type: persona
sources: [raw/stakeholder-prd-draft-digest-v0.md]
last_updated: 2026-03-25
pains: [prospects enterprise demandent le digest comme prérequis à l'achat, pas de feature digest dans le produit actuel]
goals: [débloquer des deals enterprise bloqués sur l'absence de digest, lancer rapidement sans sur-ingénieriser]
---

# Antoine — VP Product (stakeholder interne)

## Résumé

Antoine est VP Product chez NotifAI. Il représente la perspective interne de l'entreprise sur la fonctionnalité de digest — pas un utilisateur final mais un prescripteur interne avec un biais commercial fort. Son document v0 est une synthèse de sa lecture des interviews Q1, avec des hypothèses non vérifiées sur les préférences utilisateur (notamment sur l'opt-in vs opt-out de la summarisation IA).

## Ce que disent les sources

D'après raw/stakeholder-prd-draft-digest-v0.md : Antoine identifie le digest comme demande explicite de plusieurs prospects enterprise — c'est un prérequis commercial, pas seulement une demande utilisateur. Il encadre le problème comme "surcharge de notifications basses priorités."

D'après raw/stakeholder-prd-draft-digest-v0.md : Antoine propose un opt-in pour la summarisation IA ("je penche pour opt-in vu notre recherche persona") sans citer de source directe. Cette assertion n'est pas tracée vers un verbatim d'interview.

D'après raw/stakeholder-prd-draft-digest-v0.md : Antoine liste explicitement ce qu'il ne veut pas : score d'importance visible pour l'utilisateur ("trop opaque pour nos personas"), digest comme produit séparé.

## Connexions

- [[wiki/feature-digest-intelligent]] : fonctionnalité qu'il initie
- [[wiki/decision-digest-opt-in-summarisation]] : décision découlant de ses hypothèses
- [[wiki/persona-sophie-em]] : persona cible principale selon son document
- [[wiki/persona-luc-devops]] : persona cible secondaire selon son document

## Contradictions

L'assertion d'Antoine sur l'opt-in pour la summarisation IA ("vu notre recherche persona") n'est pas étayée par les verbatims disponibles dans les sources raw. Ni Sophie ni Luc n'ont exprimé de préférence explicite pour l'opt-in vs opt-out sur ce point spécifique. C'est une projection du VP, pas un fait documenté.

## Questions ouvertes

- Sur quelle source précise repose l'intuition d'Antoine pour l'opt-in ? [lacune — aucune source dans raw/ ne mentionne opt-in vs opt-out]
- Les deals enterprise bloqués ont-ils été documentés quelque part (emails, CRM) ? La pression commerciale est affirmée mais non sourcée.

## Profil

VP Product, NotifAI (équipe interne). Rôle : sponsor de la fonctionnalité digest, auteur du brief v0. Biais : commercial (débloquer des deals) > utilisateur.

## Motivations

- Débloquer des deals enterprise en livrant le digest rapidement.
- Éviter la sur-ingénierie — "partir simple, fréquence + seuil."
- Respecter les contraintes légales (données digest conservées max 24h).

## Frictions

- La recherche utilisateur existante ne valide pas directement son hypothèse d'opt-in.
- La tension entre Luc (règles explicites) et Sophie (adaptatif auditable) n'est pas résolue dans son document.

## Verbatims

Note : Antoine est un stakeholder interne. Ses "verbatims" sont des extraits de son document.

> "Several enterprise prospects have specifically asked for this as a prerequisite to buying."
> — raw/stakeholder-prd-draft-digest-v0.md

> "I lean opt-in given our persona research." [assertion non sourcée]
> — raw/stakeholder-prd-draft-digest-v0.md

## Sources

- [[raw/stakeholder-prd-draft-digest-v0.md]]

---
type: decision
sources: [raw/stakeholder-prd-draft-digest-v0.md, raw/interview-sophie-martin-2026-02.md, raw/interview-luc-bernard-2026-03.md]
last_updated: 2026-03-25
decision-date: null  # aucune décision formelle prise à ce jour
---

# Décision — Opt-in vs opt-out pour la summarisation IA du digest

## Résumé

La question de l'opt-in vs opt-out pour la summarisation IA dans le digest est ouverte. Antoine (VP Product) penche pour l'opt-in "vu la recherche persona" — mais cette assertion n'est pas tracée vers un verbatim. Les sources disponibles permettent de construire des arguments dans les deux sens. Aucune décision n'a été prise formellement à ce jour.

## Ce que disent les sources

D'après raw/stakeholder-prd-draft-digest-v0.md : Antoine affirme "I lean opt-in given our persona research." Il ne cite pas de source précise. Il mentionne cependant que l'un des risques identifiés est la "personnalisation rampante" si trop de configuration est exposée — ce qui suggère qu'il préfère limiter les choix à l'utilisateur.

D'après raw/interview-sophie-martin-2026-02.md : Sophie n'a pas été interrogée directement sur opt-in vs opt-out pour le digest. Son rejet antérieur d'un bot de résumé portait sur l'absence de sévérité dans le résumé, pas sur le fait que le résumé était activé par défaut.

D'après raw/interview-luc-bernard-2026-03.md : Luc veut contrôler explicitement ce qui entre dans le digest (seuil de sévérité qu'il définit). Pour lui, l'IA qui "decide" est suspect — mais il n'a pas été interrogé sur opt-in vs opt-out pour la summarisation du contenu du digest spécifiquement.

## Connexions

- [[wiki/feature-digest-intelligent]] : fonctionnalité à laquelle cette décision s'applique
- [[wiki/persona-sophie-em]] : persona dont les préférences influencent la décision
- [[wiki/persona-luc-devops]] : persona dont les préférences influencent la décision
- [[wiki/persona-antoine-vp-product]] : auteur de l'assertion opt-in non sourcée

## Contradictions

L'assertion d'Antoine "I lean opt-in given our persona research" est non vérifiable dans les sources raw disponibles. Ni Sophie ni Luc ne se sont prononcés sur opt-in vs opt-out pour la summarisation IA du contenu digest. La décision est présentée comme fondée sur la recherche utilisateur alors qu'elle est une projection du VP.

Arguments possibles pour opt-in (depuis les sources) :
- Luc rejette tout comportement IA qu'il n'a pas explicitement déclenché. Un résumé IA activé par défaut pourrait le bloquer.
- Les avis G2 sur DigestBot ("AI summaries are hit or miss") suggèrent que la confiance dans les résumés IA est faible — un opt-in laisse l'utilisateur choisir quand il fait confiance.

Arguments possibles pour opt-out (depuis les sources) :
- Sophie veut que son équipe bénéficie de la fonctionnalité sans avoir à la configurer. Un opt-in crée une friction d'activation pour les membres de l'équipe.
- L'enquête indique que 41 % des répondants ont testé un outil de digest IA — la résistance n'est pas universelle.

## Questions ouvertes

- Sur quelle source précise repose l'intuition d'Antoine pour l'opt-in ? [lacune — aucun verbatim dans raw/ ne tranche]
- Faut-il tester les deux modes (A/B sur les nouveaux comptes) avant de décider ?
- L'opt-in s'applique-t-il à la summarisation uniquement, ou aussi au regroupement thématique ?

## Date

Décision non prise formellement. Discussion initiée en mars 2026 par raw/stakeholder-prd-draft-digest-v0.md.

## Question

Faut-il activer la summarisation IA du contenu digest par défaut (opt-out) ou la laisser désactivée par défaut (opt-in) ?

## Décision

**Non décidé.** La fonctionnalité est en cours de spécification. Cette page documente l'état de la réflexion à date.

## Alternatives écartées

Aucune alternative formellement écartée à ce stade. Les deux options (opt-in et opt-out) restent ouvertes.

## Personnes impliquées

- Antoine Lefebvre (VP Product) — auteur du brief v0 avec position provisoire opt-in

## Sources

- [[raw/stakeholder-prd-draft-digest-v0.md]]
- [[raw/interview-sophie-martin-2026-02.md]]
- [[raw/interview-luc-bernard-2026-03.md]]

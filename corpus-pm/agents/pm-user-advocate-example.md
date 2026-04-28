# Exemple — pm-user-advocate : cas de contradiction acceptation criteria

Ce document illustre le critère d'acceptation de cor-39z :

> On a draft PRD targeting persona A but where [[persona-a]] verbatims explicitly say they DON'T want this, the agent surfaces the contradiction with the verbatim cited.

---

## Données d'entrée synthétiques

### Draft analysé : `output/2026-04-28-feature-ai-suggestions-prd.md`

```markdown
---
type: prd
feature: AI-powered task suggestions
date: 2026-04-28
status: draft
wiki-sources: [persona-marie-pm, persona-thomas-dev]
---

# PRD — Suggestions de tâches par IA

## Problème

Les product managers passent trop de temps à prioriser leur backlog manuellement.

## Objectifs

- Réduire de 50 % le temps de priorisation hebdomadaire.
- Augmenter le taux d'adoption des suggestions IA à 70 % en 3 mois.

## User stories

En tant que Marie (PM senior), je veux que l'IA suggère automatiquement les prochaines tâches à traiter afin de gagner du temps sur la priorisation. ([[wiki/persona-marie-pm]])

## Exigences

### P0 — Suggestions automatiques activées par défaut

L'IA propose une liste ordonnée de tâches à chaque ouverture du backlog, sans action de l'utilisateur.

## Critères d'acceptation

- L'utilisateur voit une liste de suggestions IA dès l'ouverture du backlog.
- Les suggestions sont classées par score de priorité calculé par le modèle.

## Métriques de succès

- 70 % des suggestions acceptées sans modification en semaine 8.
- Temps de priorisation réduit de 50 % mesuré par télémétrie.
```

### Wiki disponible

**`wiki/persona-marie-pm.md`**

```markdown
---
type: persona
sources: [raw/entretien-marie-pm-2026-03.md, raw/survey-pm-tools-2025.md]
last_updated: 2026-03-15
pains: [surcharge cognitive, perte de contexte entre sessions]
goals: [garder le contrôle sur les décisions de priorisation, réduire le bruit]
---

# Marie — PM senior

## Résumé

Marie est PM senior dans une scale-up B2B. Elle gère un backlog de 200+ tickets
et priorise en collaboration avec son équipe. Elle valorise le contrôle et la
transparence sur les décisions de priorisation.

## Ce que disent les sources

D'après raw/entretien-marie-pm-2026-03.md : Marie explique que la priorisation
est un acte délibéré, pas une tâche à déléguer. Elle a testé deux outils de
suggestion IA et les a désactivés dans la semaine.

D'après raw/survey-pm-tools-2025.md : 68 % des PM interrogés indiquent préférer
des outils qui assistent sans décider.

## Connexions

- [[wiki/interview-marie-pm-2026-03]] : entretien source
- [[wiki/segment-pm-senior-b2b]] : segment auquel Marie appartient

## Contradictions

Aucune contradiction inter-sources sur ce point.

## Questions ouvertes

Dans quelles conditions Marie accepterait-elle une assistance IA plus active ?

## Profil

PM senior, 7 ans d'expérience, scale-up B2B SaaS, équipe de 4 devs.

## Motivations

- Garder la main sur les décisions stratégiques.
- Réduire le bruit sans perdre le signal.

## Frictions

- Trop de tickets sans contexte suffisant pour prioriser rapidement.
- Outils qui décident à sa place : perte de confiance dans le backlog.

## Verbatims

> "Je ne veux pas qu'un algo décide ce qui est important. Je veux qu'il m'aide
> à voir ce que j'aurais peut-être raté, pas qu'il choisisse à ma place."
> — raw/entretien-marie-pm-2026-03.md

> "Les suggestions automatiques, j'ai essayé. Au bout de trois jours, je ne
> savais plus pourquoi une tâche était en haut. J'ai tout désactivé."
> — raw/entretien-marie-pm-2026-03.md

## Sources

- [[raw/entretien-marie-pm-2026-03.md]]
- [[raw/survey-pm-tools-2025.md]]
```

**`wiki/interview-marie-pm-2026-03.md`**

```markdown
---
type: interview
sources: [raw/entretien-marie-pm-2026-03.md]
last_updated: 2026-03-15
interview-date: 2026-03-10
---

# Entretien — Marie, PM senior, mars 2026

## Résumé

Entretien d'une heure sur les pratiques de priorisation. Marie exprime une
résistance claire aux suggestions automatiques et un besoin fort de traçabilité
des décisions.

## Ce que disent les sources

D'après raw/entretien-marie-pm-2026-03.md : Marie a testé deux outils de
suggestion IA (non nommés). Les deux ont été désactivés dans la semaine
suivant leur activation.

## Connexions

- [[wiki/persona-marie-pm]] : fiche persona correspondante

## Contradictions

Aucune.

## Questions ouvertes

Quelles conditions rendraient les suggestions IA acceptables pour Marie ?

## Date

2026-03-10

## Profil interviewé

Marie, PM senior, 7 ans d'expérience, scale-up B2B SaaS.

## Verbatims

> "Ce qui me manque c'est la confiance. Si l'IA m'explique pourquoi elle
> suggère ça, peut-être. Mais des suggestions qui apparaissent sans raison,
> non."
> — raw/entretien-marie-pm-2026-03.md

> "Le pire c'est quand l'outil décide à ma place et que je l'accepte sans
> réfléchir. Là je perds le fil de ma propre stratégie."
> — raw/entretien-marie-pm-2026-03.md

## Insights

L'acceptabilité des suggestions IA est conditionnée à leur explicabilité et
au maintien du contrôle de la PM sur la décision finale.

## Sources

- [[raw/entretien-marie-pm-2026-03.md]]
```

---

## Page de stress-test produite

**`wiki/stress-test-2026-04-28-feature-ai-suggestions-prd-user-2026-04-28.md`**

```markdown
---
type: stress-test
sources: [raw/entretien-marie-pm-2026-03.md, raw/survey-pm-tools-2025.md]
last_updated: 2026-04-28
draft: output/2026-04-28-feature-ai-suggestions-prd.md
review-angle: user
---

# Stress-test utilisateur — PRD Suggestions de tâches par IA

## Résumé

Le draft cible explicitement Marie (PM senior) comme persona principal, mais les
verbatims documentés dans [[wiki/persona-marie-pm]] et [[wiki/interview-marie-pm-2026-03]]
contredisent directement l'exigence P0 (suggestions activées par défaut). Marie a
explicitement désactivé des outils comparables. Le draft présente un risque élevé
de rejet à l'adoption. Aucun second persona n'est suffisamment documenté pour
compenser. Le niveau de confiance de la promesse principale est faible.

## Ce que disent les sources

**[[wiki/persona-marie-pm]]** : Marie valorise le contrôle sur la priorisation.
Ses frictions documentées incluent explicitement les « outils qui décident à sa place ».
Elle a testé deux outils de suggestion IA et les a désactivés dans la semaine.
Ses goals sont « garder le contrôle sur les décisions de priorisation » et « réduire
le bruit » — non pas déléguer la décision.

**[[wiki/interview-marie-pm-2026-03]]** : L'entretien de mars 2026 confirme la
résistance aux suggestions automatiques. Marie conditionne leur acceptabilité à
deux critères absents du draft : explicabilité des suggestions et maintien du
contrôle sur la décision finale. L'exigence P0 (suggestions activées par défaut,
sans action utilisateur) viole les deux conditions.

## Connexions

- [[wiki/persona-marie-pm]] : persona principal ciblé par le draft
- [[wiki/interview-marie-pm-2026-03]] : source primaire des verbatims contradictoires

## Contradictions

**Contradiction 1** : Le draft prétend résoudre le problème de Marie. Le wiki dit
que Marie ne délègue pas la priorisation à un algo.

- Draft (section User stories) : « En tant que Marie (PM senior), je veux que
  l'IA suggère automatiquement les prochaines tâches à traiter. »
- [[wiki/persona-marie-pm]] (Frictions) : « Outils qui décident à sa place :
  perte de confiance dans le backlog. »

**Contradiction 2** : L'exigence P0 active les suggestions sans action utilisateur.
Le wiki indique que Marie désactive ce type de comportement.

- Draft (Exigences P0) : « L'IA propose une liste ordonnée de tâches à chaque
  ouverture du backlog, sans action de l'utilisateur. »
- [[wiki/persona-marie-pm]] (Verbatims) : « Les suggestions automatiques, j'ai
  essayé. Au bout de trois jours, je ne savais plus pourquoi une tâche était en
  haut. J'ai tout désactivé. »

**Contradiction 3** : Le draft fixe 70 % de taux d'acceptation comme métrique de
succès. Le wiki documente une résistance de principe aux suggestions automatiques.

- Draft (Métriques de succès) : « 70 % des suggestions acceptées sans modification
  en semaine 8. »
- [[wiki/interview-marie-pm-2026-03]] (Verbatims) : « Le pire c'est quand l'outil
  décide à ma place et que je l'accepte sans réfléchir. Là je perds le fil de ma
  propre stratégie. »

## Questions ouvertes

1. Le draft peut-il être reformulé pour répondre aux conditions d'acceptabilité de
   Marie (explicabilité des suggestions, opt-in plutôt qu'opt-out) ?
2. Le persona `thomas-dev` cité dans le frontmatter du draft n'a pas de page
   `wiki/persona-thomas-dev.md` — [lacune] à documenter avant d'élargir l'analyse.
3. La survey `raw/survey-pm-tools-2025.md` (citée dans [[wiki/persona-marie-pm]])
   indique 68 % de PM préférant des outils qui « assistent sans décider » — ce
   résultat renforce la contradiction mais n'est pas ingéré comme page wiki propre.

## Personas servis

Aucun persona wiki n'est clairement servi par le draft dans sa forme actuelle.

**[[wiki/persona-marie-pm]]** — alignement partiel sur le problème (surcharge de
priorisation), mais l'exigence P0 contredit ses conditions d'acceptabilité documentées.
Le draft adresse le bon problème mais propose une solution que Marie a explicitement
rejetée dans des contextes similaires (voir Verbatims ci-dessus).

## Personas non servis

**[[wiki/persona-marie-pm]]** — Non servie par l'exigence P0 telle que formulée.

Frictions documentées ignorées par le draft :
- « Outils qui décident à sa place : perte de confiance dans le backlog. »
  → Source : [[wiki/persona-marie-pm]] § Frictions

Verbatim clé :
> "Je ne veux pas qu'un algo décide ce qui est important. Je veux qu'il m'aide
> à voir ce que j'aurais peut-être raté, pas qu'il choisisse à ma place."
> — [[wiki/persona-marie-pm]] § Verbatims, source raw/entretien-marie-pm-2026-03.md

**persona-thomas-dev** — [lacune] Le draft mentionne ce persona dans son frontmatter
(`wiki-sources: [persona-marie-pm, persona-thomas-dev]`) mais aucune page
`wiki/persona-thomas-dev.md` n'existe dans le wiki. Impossible d'évaluer l'alignement.
Déposer une source dans `raw/` et lancer `/ingest` avant de relancer cette review.

## Verbatims contradictoires

Les verbatims suivants contredisent directement les claims ou exigences du draft.
Ils sont cités mot pour mot depuis les pages wiki, sans paraphrase.

---

**Verbatim 1** — contredit l'exigence P0 (suggestions activées par défaut)

> "Les suggestions automatiques, j'ai essayé. Au bout de trois jours, je ne
> savais plus pourquoi une tâche était en haut. J'ai tout désactivé."

Source : [[wiki/persona-marie-pm]] § Verbatims → raw/entretien-marie-pm-2026-03.md

Contradiction : l'exigence P0 reproduit exactement le comportement que Marie a
rejeté : suggestions automatiques, classement opaque, activées sans action de
l'utilisateur.

---

**Verbatim 2** — contredit le claim de valeur central du draft

> "Je ne veux pas qu'un algo décide ce qui est important. Je veux qu'il m'aide
> à voir ce que j'aurais peut-être raté, pas qu'il choisisse à ma place."

Source : [[wiki/persona-marie-pm]] § Verbatims → raw/entretien-marie-pm-2026-03.md

Contradiction : le draft formule la valeur comme « suggestions automatiques »
et mesure le succès par le taux d'acceptation sans modification. Marie distingue
explicitement « aide à voir » (acceptable) de « choisit à ma place » (inacceptable).
L'exigence P0 tombe dans la seconde catégorie.

---

**Verbatim 3** — contredit la métrique de succès (70 % acceptation sans modification)

> "Le pire c'est quand l'outil décide à ma place et que je l'accepte sans
> réfléchir. Là je perds le fil de ma propre stratégie."

Source : [[wiki/interview-marie-pm-2026-03]] § Verbatims → raw/entretien-marie-pm-2026-03.md

Contradiction : la métrique cible (70 % de suggestions « acceptées sans modification »)
correspond exactement à ce que Marie décrit comme la pire expérience utilisateur.
Un taux élevé d'acceptation sans réflexion serait un signal négatif selon ses propres
termes, pas un succès.

---

**Verbatim 4** — condition d'acceptabilité absente du draft

> "Ce qui me manque c'est la confiance. Si l'IA m'explique pourquoi elle
> suggère ça, peut-être. Mais des suggestions qui apparaissent sans raison,
> non."

Source : [[wiki/interview-marie-pm-2026-03]] § Verbatims → raw/entretien-marie-pm-2026-03.md

Contradiction par omission : Marie conditionne l'acceptabilité à l'explicabilité.
Le draft ne mentionne pas d'explication des suggestions dans les critères
d'acceptation ni dans les exigences. La condition documentée dans le wiki est
absente du draft.

---

## Niveau de confiance par claim

| Claim du draft | Sources wiki | Niveau | Note |
|---|---|---|---|
| Les PMs passent trop de temps à prioriser manuellement | [[wiki/persona-marie-pm]] (Frictions : surcharge cognitive) | faible | 1 source. Le problème est documenté mais la cause est « manque de contexte », pas le volume. |
| Marie veut des suggestions automatiques | — | non documenté | [lacune] Le wiki documente l'inverse. Voir Verbatims contradictoires 1 et 2. |
| 70 % d'adoption en semaine 8 est atteignable | — | non documenté | [lacune] Aucune donnée d'adoption de fonctionnalités similaires dans le wiki. Le Verbatim 3 suggère que ce taux serait un signal négatif pour Marie. |
| Réduire de 50 % le temps de priorisation est l'objectif de Marie | [[wiki/persona-marie-pm]] (goals : réduire le bruit) | faible | L'objectif est documenté comme « réduire le bruit », pas « accélérer la priorisation ». La distinction est importante. |
| Les suggestions IA non expliquées sont acceptables pour Marie | — | non documenté | [lacune] Verbatim 4 indique explicitement le contraire. L'explicabilité est une condition préalable documentée. |

---

Sources consultées : [[wiki/persona-marie-pm]], [[wiki/interview-marie-pm-2026-03]]
```

---

## Récapitulatif de l'exécution (simulation)

```
=== Stress-test utilisateur terminé ===
Draft analysé  : /vault/output/2026-04-28-feature-ai-suggestions-prd.md
Page produite  : /vault/wiki/stress-test-2026-04-28-feature-ai-suggestions-prd-user-2026-04-28.md
Pages wiki lues: wiki/persona-marie-pm.md, wiki/interview-marie-pm-2026-03.md
Personas servis: 0 (alignement partiel uniquement sur le problème, pas la solution)
Personas non servis: 1 documenté + 1 lacune (persona-thomas-dev absent du wiki)
Verbatims contradictoires: 4
Claims non documentés (lacunes): 3
```

---

## Pourquoi cet exemple satisfait le critère d'acceptation

Le draft cible `persona-marie-pm` mais :

1. `[[wiki/persona-marie-pm]]` contient des verbatims qui disent explicitement que Marie NE VEUT PAS de suggestions automatiques.
2. `[[wiki/interview-marie-pm-2026-03]]` documente les conditions d'acceptabilité que le draft ignore.
3. L'agent a cité chaque verbatim **mot pour mot** (en langue source), nommé la page source avec le préfixe `[[wiki/...]]`, et expliqué la contradiction sans la harmoniser.
4. La métrique de succès du draft (70 % d'acceptation sans modification) est retournée comme signal négatif par un verbatim — la contradiction est non triviale et n'aurait pas été détectée sans ancrage dans le wiki.
5. La lacune sur `persona-thomas-dev` est signalée comme `[lacune]` sans invention.

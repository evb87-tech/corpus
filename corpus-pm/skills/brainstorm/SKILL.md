---
name: brainstorm
description: Pression-teste une idée produit sur trois axes — positionnement + décisions passées, personas gagnants/perdants, différenciation concurrentielle. Chaque claim est cité dans le wiki. Ne complète jamais avec des connaissances d'entraînement. Produit un rapport dans output/.
---

Vous conduisez une séance de pression-test (office hours) pour l'idée produit décrite dans `$ARGUMENTS`, à destination de `$CORPUS_VAULT/output/`.

## Règles fondamentales (anti-lissage)

Ces cinq règles s'appliquent sans exception. Voir `corpus-core/rules/07-anti-lissage.md`.

1. **Ne jamais harmoniser les contradictions.** Si deux pages wiki se contredisent sur le positionnement ou les personas, citez les deux, attribuez chacune à sa source, et signalez le conflit dans la section concernée.
2. **Ne jamais inventer une source.** Chaque claim tracé dans le rapport doit correspondre à une page wiki existante dans `$CORPUS_VAULT/wiki/`. Si vous ne pouvez pas le tracer, vous ne pouvez pas l'écrire.
3. **Ne jamais compléter silencieusement avec des connaissances d'entraînement.** Si le wiki est silencieux sur une dimension, dites-le explicitement. N'injectez pas de savoir général sur le marché, les personas génériques ou les tendances sectorielles.
4. **Ne jamais lisser la voix du propriétaire.** Si des pages `decision-*` ou `positioning-*` contiennent des formulations singulières, citez-les verbatim ou paraphrasez minimalement. La singularité est la valeur.
5. **Ne jamais produire ce rapport comme page wiki.** Ce rapport est une synthèse produit ; il va dans `output/`, jamais dans `wiki/`. Voir `corpus-core/rules/04-output-drafting.md`.

## Phase 1 — Collecte des entités wiki

1. Lisez `$CORPUS_VAULT/wiki/index.md` pour identifier les pages pertinentes.
2. Collectez dans cet ordre de priorité :
   - `Glob $CORPUS_VAULT/wiki/positioning-*.md` — positionnement produit
   - `Glob $CORPUS_VAULT/wiki/decision-*.md` — engagements et décisions passées
   - `Glob $CORPUS_VAULT/wiki/persona-*.md` — personas documentés
   - `Glob $CORPUS_VAULT/wiki/segment-*.md` — segments de marché
   - `Glob $CORPUS_VAULT/wiki/competitor-*.md` — concurrents documentés
   - `Glob $CORPUS_VAULT/wiki/feature-*.md` — fonctionnalités connexes existantes
3. Lisez chaque page trouvée en entier avant d'analyser.
4. Si `wiki/index.md` est absent ou vide, signalez-le et lisez directement les fichiers globbés.

## Phase 2 — Pression-test sur trois axes

Analysez l'idée `$ARGUMENTS` sur exactement trois axes. Chaque axis doit être fondé sur des pages wiki lues. Si le wiki est muet sur un axe entier, signalez-le avec un bloc `[lacune wiki]` — ne remplissez pas avec des connaissances générales.

### Axe A — Alignement positionnement + décisions passées

**Question :** L'idée est-elle cohérente avec le positionnement actuel et les décisions engagées ?

- Consultez les pages `positioning-*` pour le positionnement déclaré du produit.
- Consultez les pages `decision-*` pour les alternatives explicitement écartées, les engagements de non-scope, les paris stratégiques.
- Cherchez les tensions : l'idée contredit-elle une décision passée ? Élargit-elle le positionnement de façon non documentée ? Empiète-t-elle sur un scope délibérément exclu ?
- Citez chaque page consultée : `[[wiki/decision-nom]]`, `[[wiki/positioning-nom]]`.
- Si aucune page `positioning-*` ni `decision-*` n'existe : `[lacune wiki — positionnement et décisions non documentés. Déposez des sources dans raw/ et lancez /ingest.]`

### Axe B — Personas gagnants et perdants

**Question :** Quels personas bénéficient de l'idée ? Quels personas sont ignorés, pénalisés ou abandonnés ?

- Pour chaque page `persona-*` trouvée : évaluez si l'idée répond aux champs `## Motivations` et `## Frictions` du persona.
- Classez chaque persona en : **gagnant** (l'idée adresse ses frictions), **neutre** (aucun impact documenté), **perdant** (l'idée introduit une friction ou ignore ses besoins).
- Si deux personas ont des besoins contradictoires vis-à-vis de l'idée, signalez le conflit sans le résoudre.
- Citez chaque persona : `[[wiki/persona-nom]]`.
- Si aucune page `persona-*` n'existe : `[lacune wiki — aucun persona documenté. Déposez des sources dans raw/ et lancez /ingest.]`
- Si des pages `segment-*` existent, évaluez également l'impact par segment : `[[wiki/segment-nom]]`.

### Axe C — Contexte concurrentiel et différenciation

**Question :** L'idée différencie-t-elle ou reproduit-elle ce que les concurrents documentés font déjà ?

- Pour chaque page `competitor-*` trouvée : vérifiez si le concurrent documenté offre déjà une capacité similaire (champ `## Forces`), si c'est une faiblesse exploitable (champ `## Faiblesses`), et si la date `last-observed` est récente.
- Évaluez si l'idée crée une différenciation documentée ou comble un vide non couvert par les concurrents wiki.
- Citez chaque concurrent : `[[wiki/competitor-nom]]`.
- Si aucune page `competitor-*` n'existe : `[lacune wiki — aucun concurrent documenté. Déposez des sources dans raw/ et lancez /ingest.]`
- Avertissement de fraîcheur : si `last-observed` a plus de 6 mois, signalez que les données concurrentielles peuvent être périmées.

## Phase 3 — Verdict de séance

Après les trois axes, formulez un verdict synthétique en trois niveaux :

- **Idée renforcée** — les trois axes convergent en faveur ; les tensions identifiées sont mineures ou gérables.
- **Idée à affiner** — un ou deux axes soulèvent des tensions significatives ; l'idée nécessite d'être resserrée avant d'aller plus loin.
- **Idée à challenger** — au moins un axe révèle une contradiction forte avec le positionnement, une fracture persona, ou une absence de différenciation documentée.

Le verdict ne doit pas lisser les tensions : si le wiki est contradictoire, le verdict l'est aussi.

## Phase 4 — Écriture du rapport dans output/

### Nom du fichier

```
output/YYYY-MM-DD-brainstorm-<idea-slug>.md
```

- `YYYY-MM-DD` = date du jour (ISO 8601)
- `<idea-slug>` = version kebab-case ASCII de `$ARGUMENTS` (minuscules, sans accents, sans caractères spéciaux, troncation à 40 caractères si nécessaire)

### Format du fichier produit

```markdown
---
type: brainstorm
idea: <$ARGUMENTS>
date: YYYY-MM-DD
status: draft
verdict: renforcée | à affiner | à challenger
wiki-sources: [liste des slugs de pages wiki citées]
---

# Brainstorm — <Idée>

> Séance de pression-test conduite par /pm-brainstorm le YYYY-MM-DD.
> Verdict : <renforcée | à affiner | à challenger>

## A — Alignement positionnement + décisions passées

...

## B — Personas gagnants et perdants

...

## C — Contexte concurrentiel et différenciation

...

## Verdict de séance

...

## Sources wiki

Pages consultées :
- [[wiki/page-1]]
- [[wiki/page-2]]
...

Lacunes signalées :
- positioning-* : aucune page trouvée   ← si applicable
- persona-* : aucune page trouvée       ← si applicable
- competitor-* : aucune page trouvée    ← si applicable
```

N'écrivez jamais dans `wiki/` ni dans `raw/`.

## Phase 5 — Entrée dans wiki/log.md

Après avoir écrit le rapport, ajoutez une entrée dans `$CORPUS_VAULT/wiki/log.md` :

```
## [YYYY-MM-DD] brainstorm | <résumé de l'idée en une ligne>
Posture : recherche + contradicteur
Pages consultées : [[wiki/page-1]], [[wiki/page-2]]
Rapport produit : output/YYYY-MM-DD-brainstorm-<idea-slug>.md
Verdict : <renforcée | à affiner | à challenger>
```

## Comportement en cas de wiki vide

Si le wiki ne contient aucune page `positioning-*`, `decision-*`, `persona-*`, `competitor-*` ni `feature-*` :

1. Ne produisez PAS un rapport avec des sections inventées.
2. Signalez la lacune au propriétaire :

   > Le wiki ne contient aucune entité PM (positionnement, décisions, personas, concurrents, fonctionnalités). Une séance de pression-test fiable nécessite ces données. Options : (a) déposez des sources dans `raw/` et lancez `/ingest` ; (b) demandez explicitement une analyse marquée entièrement `[non vérifié]`.

3. Attendez l'accord explicite du propriétaire avant de produire un contenu non tracé.

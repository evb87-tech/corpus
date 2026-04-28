---
name: feature-spec
description: Rédige un PRD structuré (Product Requirements Document) en français à partir des entités wiki — personas, concurrents, décisions, fonctionnalités connexes. Applique les règles anti-lissage : ne jamais inventer de persona ou de concurrent absent du wiki, signaler toute lacune explicitement.
---

Vous rédigez un PRD pour la fonctionnalité décrite dans `$ARGUMENTS`, à destination de `$CORPUS_VAULT/output/`.

## Règles fondamentales (anti-lissage)

Ces règles s'appliquent sans exception. Voir `corpus-core/rules/07-anti-lissage.md`.

1. **Ne jamais inventer un persona.** Si aucune page `persona-*` n'existe dans le wiki, ne rédigez pas de section User Stories ou Personas sans l'avoir signalé. Marquez la section `[lacune — aucun persona dans le wiki]` et proposez au propriétaire de déposer une source dans `raw/`.
2. **Ne jamais inventer un concurrent.** Si aucune page `competitor-*` n'existe, marquez la section Positionnement `[lacune — aucun concurrent dans le wiki]`.
3. **Ne jamais compléter silencieusement avec des connaissances d'entraînement.** Si une section requiert des informations absentes du wiki, signalez la lacune explicitement. Vous pouvez proposer un contenu de remplissage marqué `[non vérifié — connaissance d'entraînement, non tracée dans le wiki]` uniquement si le propriétaire l'accepte explicitement.
4. **Ne jamais harmoniser les contradictions.** Si deux pages wiki se contredisent, citez les deux et placez le conflit dans une note sous la section concernée.
5. **Citer toutes les pages wiki consultées** à la fin du document, sous `## Sources wiki`.

## Taxonomie des sections du PRD

Le PRD produit les sections suivantes, dans cet ordre, en français. Les titres de section sont fixes (ne pas traduire ni reformuler).

### 1. Problème

Décrivez le problème utilisateur ou métier que cette fonctionnalité résout. Basez-vous sur :
- les champs `## Frictions` et `## Motivations` des pages `persona-*`
- les champs `## Problème` des pages `feature-*` connexes

Si aucune page pertinente n'existe : `[lacune — problème non documenté dans le wiki]`.

### 2. Objectifs

Listez les objectifs mesurables de la fonctionnalité. Reliez chaque objectif à une page wiki source quand c'est possible. Format recommandé : liste à puces.

### 3. Hors périmètre

Listez explicitement ce que cette fonctionnalité ne couvre PAS. Appuyez-vous sur :
- les décisions passées dans `decision-*` (alternatives écartées)
- les fonctionnalités connexes dans `feature-*` qui couvrent déjà certains aspects

### 4. User stories

Format : `En tant que <persona>, je veux <action> afin de <bénéfice>.`

**Contrainte forte** : chaque persona nommé ici doit correspondre à une page `persona-*` existante dans le wiki. Citez la page en ligne : `([[persona-nom]])`. Si aucun persona wiki n'existe, remplacez cette section par :

> [lacune — aucun persona documenté dans le wiki. Déposez une source dans `raw/` et lancez `/ingest` avant de compléter cette section.]

### 5. Exigences

Classez les exigences en trois niveaux de priorité :

- **P0** — bloquant pour le lancement (must-have)
- **P1** — important, peut suivre dans un cycle suivant
- **P2** — souhaitable, différable

Format pour chaque exigence : `- [P0|P1|P2] <description de l'exigence>`. Tracez chaque exigence P0 vers une page wiki source si possible.

### 6. Critères d'acceptation

Listez les conditions vérifiables qui définissent « fait ». Format : liste à puces, une condition par ligne, formulée de façon testable (ex. : « L'utilisateur peut effectuer X sans Y »).

### 7. Métriques de succès

Listez les métriques quantifiables qui indiqueront si la fonctionnalité a atteint ses objectifs. Reliez si possible aux `goals` des pages `persona-*` ou aux métriques mentionnées dans les pages `feature-*`.

Si aucune métrique n'est documentée dans le wiki : `[lacune — métriques de succès non documentées dans le wiki]`.

## Positionnement concurrentiel (section optionnelle)

Si des pages `competitor-*` existent dans le wiki et sont pertinentes pour la fonctionnalité, ajoutez une section `## Positionnement` après `## Métriques de succès`. Résumez comment cette fonctionnalité se différencie des concurrents documentés. Citez chaque page `[[competitor-nom]]` utilisée.

Si aucune page `competitor-*` n'existe : omettez la section ou écrivez `[lacune — aucun concurrent documenté dans le wiki]`.

## Engagements préalables (section optionnelle)

Si des pages `decision-*` pertinentes existent, ajoutez une section `## Décisions liées` listant les décisions passées qui contraignent ou orientent cette fonctionnalité. Citez chaque page `[[decision-nom]]`.

## Citations wiki

Terminez le document par :

```
## Sources wiki

Pages consultées :
- [[wiki/page-1]]
- [[wiki/page-2]]
...

Pages absentes (lacunes signalées) :
- persona-* : aucune page trouvée   ← si applicable
- competitor-* : aucune page trouvée ← si applicable
```

## Format du fichier produit

```markdown
---
type: prd
feature: <nom de la fonctionnalité>
date: YYYY-MM-DD
status: draft
wiki-sources: [liste des slugs de pages wiki citées]
---

# PRD — <Nom de la fonctionnalité>

> Rédigé par /pm-spec le YYYY-MM-DD. Statut : brouillon.

## Problème
...

## Objectifs
...

## Hors périmètre
...

## User stories
...

## Exigences
...

## Critères d'acceptation
...

## Métriques de succès
...

[## Positionnement]   ← si applicable

[## Décisions liées]  ← si applicable

## Sources wiki
...
```

## Comportement en cas de lacune majeure

Si le wiki est vide (aucune page `persona-*`, `competitor-*`, `decision-*`, `feature-*`), ne produisez PAS un PRD avec des sections inventées. À la place :

1. Signalez la lacune au propriétaire :
   > Le wiki ne contient aucune entité PM (personas, concurrents, décisions, fonctionnalités). Un PRD fiable nécessite ces données. Options : (a) déposez des sources dans `raw/` et lancez `/ingest` ; (b) demandez explicitement un brouillon marqué entièrement `[non vérifié]`.
2. Attendez l'accord explicite du propriétaire avant de produire un contenu non tracé.

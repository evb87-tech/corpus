---
name: roadmap-update
description: Produit un document de roadmap dans output/ en croisant l'état actuel des epics beads avec les décisions et priorités documentées dans le wiki. Applique les règles anti-lissage — ne jamais compléter avec des connaissances d'entraînement, citer le wiki pour chaque affirmation de scope ou de priorité.
---

Vous produisez un document de roadmap à destination de `$CORPUS_VAULT/output/`, commandé via `/pm-roadmap-update`. L'argument optionnel `$ARGUMENTS` fournit un titre ou un périmètre (ex. : « Q2 orienté clients »).

## Règles fondamentales (anti-lissage)

Ces règles s'appliquent sans exception. Voir `corpus-core/rules/07-anti-lissage.md`.

1. **Ne jamais inventer une priorité.** Si le wiki ne documente pas la priorité d'un epic, écrivez `[priorité non documentée dans le wiki]` — n'en déduisez pas une depuis votre connaissance d'entraînement.
2. **Ne jamais compléter silencieusement.** Si le wiki est vide de décisions, dites-le explicitement. Ne produisez pas de section « Vision » avec du discours stratégique générique.
3. **Ne jamais harmoniser les contradictions.** Si deux décisions wiki se contredisent sur le périmètre, citez les deux et signalez le conflit sous la section concernée.
4. **Citer toutes les pages wiki consultées** à la fin du document, sous `## Sources`.
5. **La roadmap est un livrable `output/`.** Elle ne doit jamais être déposée dans `wiki/`. Voir `corpus-core/rules/01-folder-discipline.md`.

## Étape 1 — Vérifier la présence de `bd`

Avant toute chose, vérifiez que la commande `bd` est disponible dans le runtime :

```bash
which bd 2>/dev/null || echo "ABSENT"
```

Si `bd` est absent, refusez avec le message suivant et arrêtez :

> **Erreur : `bd` est introuvable dans le runtime.**
> La commande `/pm-roadmap-update` requiert l'outil beads (`bd`) pour lire les epics.
> Installez-le : https://github.com/draftcode/beads (ou suivez les instructions de votre équipe).
> Une fois installé, relancez `/pm-roadmap-update`.

## Étape 2 — Lire les epics beads

Exécutez :

```bash
bd list --type epic --json --limit 0
```

Le flag `--json` est un flag global de `bd` ; `--limit 0` désactive la pagination (50 par défaut).

Si la commande échoue (erreur de base de données, répertoire `.beads` absent, etc.), refusez avec un message explicite indiquant la commande qui a échoué et son message d'erreur. Ne continuez pas.

Pour chaque epic retourné, notez : `id`, `title`, `status`, `description` (si présente), et les éventuels blockers (champ `blocked_by` ou labels `blocked`).

Classez les epics en trois groupes :
- **En cours** (`status: in_progress`)
- **Prochain** (`status: open` sans bloquant identifié)
- **Bloqué** (`status: blocked`, ou `status: open` avec un bloquant identifié)

Si aucun epic n'existe dans la base, signalez-le et produisez quand même le document avec les sections vides plutôt que de l'abandonner.

## Étape 3 — Lire le wiki

### Décisions (obligatoire)

```bash
Glob $CORPUS_VAULT/wiki/decision-*.md
```

Pour chaque fichier trouvé, lisez le frontmatter complet + la section `## Décision`. Ne lisez pas les sections moins prioritaires sauf si le périmètre de l'argument `$ARGUMENTS` les rend explicitement pertinentes.

Si aucune page `decision-*` n'existe, notez la lacune — la section Vision sera explicitement vide.

### Fonctionnalités et segments (optionnel)

Si `$ARGUMENTS` mentionne un périmètre spécifique (ex. : « onboarding », « B2B »), scannez également :

```bash
Glob $CORPUS_VAULT/wiki/feature-*.md
Glob $CORPUS_VAULT/wiki/segment-*.md
```

Lisez uniquement les pages dont le titre ou le frontmatter correspond au périmètre indiqué. Ne lisez pas tout le wiki si le scope n'est pas précisé.

## Étape 4 — Produire la roadmap

Fichier de sortie : `$CORPUS_VAULT/output/YYYY-MM-DD-roadmap.md`
- `YYYY-MM-DD` = date du jour (ISO 8601)
- Si `$ARGUMENTS` est fourni, suffixez le slug : `output/YYYY-MM-DD-roadmap-<slug>.md` où `<slug>` est la version kebab-case ASCII de `$ARGUMENTS` (minuscules, sans accents, sans caractères spéciaux).

N'écrivez jamais dans `wiki/` ni dans `raw/`.

### Taxonomie des sections (ordre fixe)

#### Vision

Citez uniquement ce que les pages `decision-*` documentent comme orientation stratégique ou priorités de haut niveau. Chaque phrase citable doit référencer sa source : `([[wiki/decision-slug]])`.

Si aucune décision wiki ne documente la vision ou les priorités :

> [lacune — aucune page `decision-*` dans le wiki ne documente la vision ou les priorités produit. Déposez une source dans `raw/` et lancez `/ingest` pour alimenter cette section.]

Ne rédigez pas de discours stratégique générique à la place.

#### En cours

Liste des epics avec `status: in_progress`. Pour chaque epic :
- Titre + identifiant bead (ex. : `cor-8x8`)
- Description courte (depuis le champ `description` du bead si disponible)
- Référence wiki si une page `decision-*` ou `feature-*` documente le contexte de cet epic : `([[wiki/slug]])`

Si aucun epic n'est en cours : `> Aucun epic en cours au YYYY-MM-DD.`

#### Prochain

Liste des epics `open` sans bloquant, représentant le backlog prêt à démarrer. Même format qu'« En cours ». Citez le wiki si une décision documente la priorité de l'epic.

Si aucun epic n'est prêt : `> Aucun epic prêt à démarrer au YYYY-MM-DD.`

#### Bloqué

Liste des epics bloqués. Pour chaque epic :
- Titre + identifiant bead
- Nature du blocage (depuis le champ `blocked_by` ou les notes du bead)
- Référence wiki si le blocage est documenté : `([[wiki/slug]])`

Si aucun epic n'est bloqué : `> Aucun epic bloqué au YYYY-MM-DD.`

#### Décisions structurantes

Listez toutes les pages `decision-*` lues à l'étape 3, avec un résumé d'une phrase de chaque décision. Format :

```
- [[wiki/decision-slug]] — <résumé d'une phrase de la décision>
```

Si aucune page `decision-*` n'existe : `> [lacune — aucune décision structurante documentée dans le wiki.]`

#### Sources

```
## Sources

Pages wiki consultées :
- [[wiki/page-1]]
- [[wiki/page-2]]
...

Pages absentes (lacunes signalées) :
- decision-* : aucune page trouvée   ← si applicable
- feature-* : aucune page lue (périmètre non précisé)  ← si applicable
```

## Format du fichier produit

```markdown
---
type: roadmap
date: YYYY-MM-DD
scope: <valeur de $ARGUMENTS ou "général">
status: draft
bead-snapshot: YYYY-MM-DD
wiki-sources: [liste des slugs de pages wiki citées]
---

# Roadmap — <scope>

> Produit par /pm-roadmap-update le YYYY-MM-DD. Statut : brouillon.
> Snapshot epics : YYYY-MM-DD. Sources wiki : voir section Sources.

## Vision

...

## En cours

...

## Prochain

...

## Bloqué

...

## Décisions structurantes

...

## Sources

...
```

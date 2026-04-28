# Exemple — /pm-review-strategy

> Cet exemple illustre le comportement attendu du sous-agent `pm-strategist` sur deux cas synthétiques. Il sert de référence pour les tests d'acceptance de cor-wx9.

---

## Cas 1 — Brouillon contredisant `wiki/decision-no-xml.md`

### Vault de départ (seeded)

```
wiki/
  index.md
  log.md
  decision-no-xml.md        — type: decision, décision: pas de support XML dans v1, alternatives écartées: XML, XLSX
  feature-export-csv.md     — type: feature, problème: export manuel laborieux
output/
  2026-04-28-export-all-formats-prd.md
```

Contenu de `wiki/decision-no-xml.md` (extrait pertinent) :

```markdown
---
type: decision
sources: [raw/architecture-review-2025.md]
last_updated: 2026-01-15
decision-date: 2026-01-15
---

# Pas de support XML en v1

## Résumé

L'équipe a décidé de ne pas implémenter l'export XML dans la version 1 du produit pour contenir la complexité initiale.

## Ce que disent les sources

- [[raw/architecture-review-2025.md]] : « Le support XML double le coût de maintenance du pipeline d'export sans bénéfice utilisateur démontré au stade v1. »

## Connexions

- [[wiki/feature-export-csv]] : fonctionnalité d'export retenue pour v1

## Contradictions

Aucune.

## Questions ouvertes

Réévaluation prévue pour v2 si la demande utilisateur le justifie.

## Date

2026-01-15

## Question

Faut-il inclure l'export XML dans le périmètre v1 ?

## Décision

Non. L'export XML est explicitement hors périmètre pour la v1. Seul le CSV est retenu.

## Alternatives écartées

- XML : coût de maintenance trop élevé sans bénéfice v1 démontré.
- XLSX : différé à v2 selon la demande.

## Personnes impliquées

Équipe architecture, PM.

## Sources

- [[raw/architecture-review-2025.md]]
```

Contenu du brouillon `output/2026-04-28-export-all-formats-prd.md` (extrait) :

```markdown
---
type: prd
feature: export tous formats
date: 2026-04-28
status: draft
---

# PRD — Export tous formats

## Problème

Les utilisateurs ont besoin d'exporter leurs données dans plusieurs formats pour s'intégrer à leurs outils métier.

## Exigences

- [P0] L'utilisateur peut exporter en CSV.
- [P0] L'utilisateur peut exporter en XML pour les intégrations legacy.
- [P1] L'utilisateur peut exporter en XLSX.
```

### Commande lancée

```
/pm-review-strategy output/2026-04-28-export-all-formats-prd.md
```

### Comportement attendu du sous-agent

**Étape 1 — Lecture du wiki :** le sous-agent lit `wiki/index.md`, puis `wiki/decision-no-xml.md` et `wiki/feature-export-csv.md`.

**Étape 2 — Analyse des décisions contredites :** le sous-agent détecte que le brouillon inclut une exigence P0 pour l'export XML, ce qui contredit directement `wiki/decision-no-xml.md`.

**Étape 3 — Page de stress-test produite :**

Fichier : `wiki/stress-test-export-all-formats-prd-strategy-2026-04-28.md`

```markdown
---
type: stress-test
sources: [wiki/decision-no-xml, wiki/feature-export-csv]
last_updated: 2026-04-28
draft: output/2026-04-28-export-all-formats-prd.md
angle: strategy
---

# Stress-test stratégie — Export tous formats

## Résumé

Le brouillon contredit une décision wiki documentée : l'export XML a été explicitement écarté pour la v1 par [[wiki/decision-no-xml]]. L'exigence P0 pour l'export XML doit être réexaminée avant validation du périmètre. L'export XLSX (P1) est également en tension avec la même décision.

## Ce que disent les sources

- [[wiki/decision-no-xml]] : la décision du 2026-01-15 écarte explicitement XML et XLSX du périmètre v1. Citation : « Le support XML double le coût de maintenance du pipeline d'export sans bénéfice utilisateur démontré au stade v1. »
- [[wiki/feature-export-csv]] : la fonctionnalité d'export CSV est documentée comme la solution retenue pour le problème d'export v1.

## Connexions

- [[wiki/decision-no-xml]] : décision directement contredite par les exigences P0 et P1 du brouillon
- [[wiki/feature-export-csv]] : fonctionnalité connexe déjà dans le wiki, cohérente avec l'exigence P0 CSV du brouillon

## Contradictions

**Contradiction 1 — Export XML (P0) vs [[wiki/decision-no-xml]] :**
Le brouillon pose comme exigence P0 : « L'utilisateur peut exporter en XML pour les intégrations legacy. »
La décision wiki tranche explicitement : « Non. L'export XML est explicitement hors périmètre pour la v1. Seul le CSV est retenu. »
Cette contradiction est directe et non ambiguë.

**Contradiction 2 — Export XLSX (P1) vs [[wiki/decision-no-xml]] :**
Le brouillon inclut l'export XLSX en P1.
La décision wiki liste XLSX dans les alternatives écartées : « XLSX : différé à v2 selon la demande. »
Inclure XLSX sans réouvrir formellement cette décision contredit le log de décision.

## Questions ouvertes

- La décision [[wiki/decision-no-xml]] a-t-elle été formellement rouverte ? Si oui, déposer le document de réévaluation dans `raw/` et relancer `/ingest`.
- Les « intégrations legacy » mentionnées dans l'exigence XML ont-elles été documentées quelque part dans le wiki ? [lacune — aucune page wiki ne mentionne de contrainte d'intégration legacy]

## Périmètre

Le périmètre du brouillon est plus large que ce que le wiki autorise pour v1. Deux formats (XML, XLSX) ont été explicitement écartés par [[wiki/decision-no-xml]]. L'inclusion de ces formats sans décision de révision documentée élargit le périmètre au-delà des engagements wiki.

La partie CSV du périmètre est cohérente avec [[wiki/feature-export-csv]] et [[wiki/decision-no-xml]].

## Séquencement

Pas de prérequis bloquants documentés dans le wiki pour l'export CSV (cohérent avec [[wiki/feature-export-csv]]). Pour XML et XLSX, le séquencement est prématuré tant que [[wiki/decision-no-xml]] n'est pas formellement revisitée.

## Coût d'opportunité

[[wiki/decision-no-xml]] indique que le support XML double le coût de maintenance du pipeline d'export. Le brouillon ne documente pas comment ce coût est absorbé ni quelle fonctionnalité est désengagée en contrepartie. Le wiki est muet sur les ressources disponibles — impossible de quantifier le déplacement sans source supplémentaire.

## Décisions contredites

> **[[wiki/decision-no-xml]]** (décision datée du 2026-01-15) : « Non. L'export XML est explicitement hors périmètre pour la v1. Seul le CSV est retenu. »
> Le brouillon contredit cette décision en : posant l'export XML comme exigence P0 et l'export XLSX comme exigence P1, sans mention d'une révision formelle de la décision.
```

### Points illustrés par ce cas

1. **Contradiction surfacée et citée verbatim** : le sous-agent cite la section `## Décision` de `wiki/decision-no-xml.md` mot pour mot, sans paraphraser.
2. **Liens `[[wiki/...]]` systématiques** : chaque référence utilise la forme complète avec préfixe `wiki/`.
3. **Lacune notée `[lacune]`** : les intégrations legacy non documentées sont signalées sans invention.
4. **Pas d'harmonisation** : le sous-agent ne choisit pas entre le brouillon et la décision — il pose la contradiction et laisse la résolution au propriétaire.

---

## Cas 2 — Brouillon cohérent avec tout le contexte wiki

### Vault de départ (seeded)

```
wiki/
  index.md
  log.md
  decision-no-xml.md        — même contenu que ci-dessus
  feature-export-csv.md     — type: feature, problème: export manuel laborieux
output/
  2026-04-28-export-csv-prd.md
```

Contenu du brouillon `output/2026-04-28-export-csv-prd.md` (extrait) :

```markdown
---
type: prd
feature: export CSV
date: 2026-04-28
status: draft
wiki-sources: [decision-no-xml, feature-export-csv]
---

# PRD — Export CSV

## Problème

Les utilisateurs ne peuvent pas exporter leurs données sans manipulation manuelle.

## Exigences

- [P0] L'utilisateur peut exporter en CSV depuis toute vue tabulaire.
- [P0] Le fichier CSV est encodé en UTF-8 avec séparateur virgule.
- [P1] L'utilisateur peut filtrer les colonnes avant export.

## Hors périmètre

- Export XML : hors périmètre v1 (voir decision-no-xml).
- Export XLSX : différé à v2.
```

### Commande lancée

```
/pm-review-strategy output/2026-04-28-export-csv-prd.md
```

### Comportement attendu du sous-agent

**Étape 1 — Lecture du wiki :** le sous-agent lit `wiki/index.md`, puis `wiki/decision-no-xml.md` et `wiki/feature-export-csv.md`.

**Étape 2 — Analyse des décisions contredites :** le sous-agent vérifie que toutes les exigences du brouillon sont dans le périmètre autorisé par les décisions wiki. XML et XLSX sont explicitement marqués hors périmètre dans le brouillon, conformément à `wiki/decision-no-xml.md`. Aucune contradiction détectée.

**Étape 3 — Page de stress-test produite :**

Fichier : `wiki/stress-test-export-csv-prd-strategy-2026-04-28.md`

```markdown
---
type: stress-test
sources: [wiki/decision-no-xml, wiki/feature-export-csv]
last_updated: 2026-04-28
draft: output/2026-04-28-export-csv-prd.md
angle: strategy
---

# Stress-test stratégie — Export CSV

## Résumé

Aucune préoccupation majeure de périmètre. Le brouillon est cohérent avec les deux pages wiki consultées. Les formats XML et XLSX sont correctement exclus conformément à [[wiki/decision-no-xml]]. Le problème adressé correspond à la friction documentée dans [[wiki/feature-export-csv]].

## Ce que disent les sources

- [[wiki/decision-no-xml]] : XML et XLSX sont hors périmètre v1. Le brouillon le respecte explicitement dans sa section « Hors périmètre ».
- [[wiki/feature-export-csv]] : le problème d'export manuel laborieux est bien documenté. Le brouillon l'adresse directement.

## Connexions

- [[wiki/decision-no-xml]] : respectée — les formats écartés sont listés dans « Hors périmètre » du brouillon
- [[wiki/feature-export-csv]] : alignée — le brouillon adresse exactement le problème documenté dans la page feature

## Contradictions

Aucune contradiction détectée entre le brouillon et les pages wiki consultées.

## Questions ouvertes

- Le wiki ne documente pas de métriques de succès pour l'export CSV. Si des objectifs chiffrés sont ajoutés au brouillon, ils ne pourront pas être tracés vers une source wiki actuelle.
- Aucune page `wiki/persona-*` n'existe dans le wiki — impossible de vérifier l'alignement utilisateur depuis cet angle (hors périmètre du stress-test stratégie, mais notable).

## Périmètre

Le périmètre du brouillon est bien délimité et cohérent avec le wiki. Les exigences P0 et P1 portent exclusivement sur le CSV, ce que [[wiki/decision-no-xml]] autorise pour v1. La section « Hors périmètre » du brouillon est explicitement alignée avec les alternatives écartées dans [[wiki/decision-no-xml]].

## Séquencement

Pas de prérequis bloquants documentés dans le wiki. [[wiki/feature-export-csv]] est une feature de périmètre v1 sans dépendances documentées.

## Coût d'opportunité

Le wiki ne documente pas d'autres features en compétition directe avec l'export CSV pour les mêmes ressources. Impossible de quantifier le coût d'opportunité sans source wiki supplémentaire.

## Décisions contredites

Aucune décision wiki contredite. Pages consultées : [[wiki/decision-no-xml]], [[wiki/feature-export-csv]].
```

**Récapitulatif affiché par le sous-agent :**

```
=== Stress-test stratégie terminé ===
Brouillon   : /vault/output/2026-04-28-export-csv-prd.md
Stress-test : /vault/wiki/stress-test-export-csv-prd-strategy-2026-04-28.md
Pages wiki consultées :
  - [[wiki/decision-no-xml]]
  - [[wiki/feature-export-csv]]
Contradictions trouvées : aucune
Lacunes notées : 2 (métriques de succès non tracées, personas absents)
```

### Points illustrés par ce cas

1. **"Aucune préoccupation majeure de périmètre"** : le sous-agent le dit explicitement dans le Résumé — il ne fabrique pas de critiques pour paraître utile.
2. **Liste des pages consultées** : même sans contradiction, le sous-agent documente ce qu'il a vérifié, rendant le résultat auditable.
3. **Lacunes signalées honnêtement** : les questions ouvertes pointent des angles non couverts (métriques, personas) sans les inventer.
4. **Section `## Décisions contredites` explicite** : même vide, la section liste les décisions consultées pour traçabilité.
5. **Anti-lissage respecté** : le sous-agent ne produit pas de synthèse inventée sur "comment améliorer le brouillon" — son rôle est de tester, pas de réécrire.

---

## Cas limite — wiki vide (arrêt dur)

Si le vault ne contient aucune page `wiki/decision-*` ni `wiki/feature-*`, le sous-agent refuse immédiatement :

```
ARRÊT : Le wiki ne contient aucune page decision-* ni feature-*.
Un stress-test stratégique sans entités wiki ne fait que refléter la connaissance d'entraînement, ce qui viole les règles anti-lissage.
Déposez des sources dans raw/ et lancez /ingest avant de relancer /pm-review-strategy.
```

Aucune page de stress-test n'est produite. Aucune écriture dans le vault.

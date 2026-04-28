---
name: review-feasibility
description: Stress-teste un brouillon (PRD ou roadmap) sous l'angle faisabilité technique. Croise les claims techniques du brouillon avec les pages wiki/decision-* et wiki/feature-* pour surfacer les conflits avec l'architecture documentée. Conçue pour un propriétaire côté produit qui prépare une discussion ingénierie. Applique les règles anti-lissage — refuse si aucune décision n'existe au wiki. Triggers — est-ce techniquement faisable, auditer la faisabilité, vérifier la cohérence avec l'archi.
---

# Skill — review-feasibility

Tu es la skill **corpus-pm:review-feasibility**. Ton unique rôle est de stress-tester un brouillon sous l'angle de la faisabilité technique : les claims du brouillon sont-ils soutenus ou contredits par les décisions d'architecture et les pages feature documentées dans le wiki ?

Ce rôle est conçu pour un propriétaire côté produit. Tu surfaces les préoccupations d'ingénierie qu'il peut ensuite apporter à son interlocuteur technique — tu ne tranches pas à sa place.

## Entrée attendue

Un chemin absolu vers un fichier dans `$CORPUS_VAULT/output/`.

## Règles fondamentales (anti-lissage)

Ces règles s'appliquent sans exception. Voir `corpus-core/rules/07-anti-lissage.md`.

1. **Citer avec le préfixe `[[wiki/...]]`.** Toujours `[[wiki/decision-nom]]` et `[[wiki/feature-nom]]`. Jamais de lien nu comme `[[decision-nom]]`.
2. **Ne jamais inventer une décision ou une contrainte technique.** Si le brouillon mentionne une décision qui n'existe pas comme page `wiki/decision-*`, noter `[lacune — décision non documentée dans le wiki]`. Ne jamais compléter par conjecture ou par connaissance d'entraînement.
3. **Ne jamais harmoniser une contradiction.** Si une décision wiki contredit un claim du brouillon, citer la décision verbatim depuis sa section `## Décision` et nommer la page source.
4. **Arrêt dur si le wiki ne contient aucune page `decision-*`.** Refuser immédiatement avec :

```
ARRÊT : Le wiki ne contient aucune page decision-*.
Un stress-test de faisabilité sans décisions d'architecture documentées ne ferait que refléter la connaissance d'entraînement, ce qui viole les règles anti-lissage.
Options :
  (a) Déposez des comptes-rendus de décisions d'architecture dans raw/ et lancez /ingest.
  (b) Relancez /pm-review-feasibility une fois les pages wiki/decision-* disponibles.
Aucune page de stress-test créée.
```

5. **Ne jamais compléter silencieusement avec des connaissances d'entraînement.** Si une section requiert des informations absentes du wiki, marquer `[lacune]` et expliquer ce qui manque.

## Protocole d'exécution

### Étape 0 — Résolution du vault

```bash
if [ -z "$CORPUS_VAULT" ]; then
  echo "CORPUS_VAULT non défini. Impossible de continuer." >&2
  exit 1
fi
if [ ! -f "$CORPUS_VAULT/.corpus-vault" ]; then
  echo "Marqueur .corpus-vault absent. Lancer /init-vault <chemin>." >&2
  exit 1
fi
```

### Étape 1 — Lecture du brouillon

Lire le fichier brouillon en entier. Identifier :
- Le titre du brouillon (H1).
- Le type de document (frontmatter `type:` si présent, sinon déduire depuis le nom de fichier ou le contenu).
- Le slug du brouillon : basename du fichier sans extension, partie significative (retirer le préfixe de date `YYYY-MM-DD-` si présent). Ex. `2026-04-28-feature-notifications-prd` → `feature-notifications-prd`.
- Les **claims techniques** : toute affirmation qui porte sur la faisabilité, la complexité d'implémentation, les dépendances système, les performances attendues, les risques d'intégration, les APIs tierces, la scalabilité, la migration de données, ou la charge d'infrastructure. Inclure aussi les assumptions implicites (ex. « l'intégration sera simple »).

### Étape 2 — Inventaire wiki

```bash
ls "$CORPUS_VAULT/wiki/decision-"*.md 2>/dev/null || true
ls "$CORPUS_VAULT/wiki/feature-"*.md 2>/dev/null || true
```

Utiliser Glob pour lister `$CORPUS_VAULT/wiki/decision-*.md` et `$CORPUS_VAULT/wiki/feature-*.md`.

Si la liste `decision-*` est vide → **arrêt dur** (cf. règle 4 ci-dessus).

Si `decision-*` existe mais `feature-*` est vide → continuer sur les seules pages `decision-*`, en notant l'absence de pages `feature-*` dans la section `## Questions ouvertes`.

Lire `$CORPUS_VAULT/wiki/index.md` en premier pour orienter la sélection. Lire ensuite chaque page `decision-*` et `feature-*` en entier.

### Étape 3 — Analyse en quatre axes

#### Axe 1 : Faisabilité des claims techniques

Pour chaque claim technique identifié à l'étape 1 :
- Existe-t-il une page `wiki/decision-*` ou `wiki/feature-*` qui le corrobore, le nuance ou le contredit ?
- Si corroboration : citer la section pertinente avec `[[wiki/...]]`.
- Si contradiction : voir Axe 4 (décisions contredites).
- Si le wiki est muet sur ce claim : marquer `[lacune — aucune source wiki sur ce point]` et ne pas spéculer.
- Évaluer le niveau de confiance du claim au regard des sources wiki disponibles : `ancré` (au moins une décision wiki alignée), `non documenté` (wiki muet), `contredit` (au moins une décision wiki en opposition).

#### Axe 2 : Dépendances

Pour chaque dépendance implicite ou explicite du brouillon (APIs, services tiers, composants internes, schémas de données, infrastructure) :
- Cette dépendance est-elle documentée dans une page `wiki/decision-*` ou `wiki/feature-*` ?
- Si oui : citer la page avec `[[wiki/...]]` et noter si la dépendance est validée, différée ou écartée.
- Si non : marquer `[lacune — dépendance non documentée dans le wiki]`.

#### Axe 3 : Risques d'intégration

Pour chaque risque d'intégration détectable depuis les pages wiki consultées :
- Y a-t-il des décisions antérieures qui contraignent l'interface, le protocole, ou le format de données ?
- Des pages `wiki/feature-*` documentent-elles des frictions d'intégration similaires ?
- Si un risque est identifié depuis le wiki : le citer avec `[[wiki/...]]` et expliquer comment il s'applique au brouillon.
- Si le wiki est muet : le dire explicitement sans inventer de risques.

#### Axe 4 : Décisions contredites

Comparer le brouillon à chaque page `wiki/decision-*` :
- Le brouillon inclut-il quelque chose qu'une décision wiki a explicitement écarté ?
- Le brouillon contredit-il une contrainte technique documentée ?
- Pour chaque contradiction : citer la décision **verbatim** depuis sa section `## Décision`, nommer la page source avec `[[wiki/...]]`, et décrire précisément la contradiction.
- Si aucune contradiction n'est trouvée : le dire explicitement et lister les décisions consultées.

Format recommandé pour l'axe 4 :

> **[[wiki/decision-nom]]** (décision datée du <date>) : « <citation verbatim de la section ## Décision> »
> Le brouillon contredit cette décision en : <description précise>.

### Étape 4 — Dériver le slug et le chemin de sortie

```bash
DRAFT_BASENAME=$(basename "$1" .md)
# Retirer le préfixe de date YYYY-MM-DD- si présent
DRAFT_SLUG=$(echo "$DRAFT_BASENAME" | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//')
TODAY=$(date +%Y-%m-%d)
STRESS_SLUG="stress-test-${DRAFT_SLUG}-feasibility-${TODAY}"
STRESS_PATH="$CORPUS_VAULT/wiki/${STRESS_SLUG}.md"
DRAFT_RELATIVE="${1#$CORPUS_VAULT/}"
```

### Étape 4bis — Calculer le champ `sources` (raw/ uniquement)

Per `corpus-core/rules/02-wiki-page-format.md`, le champ `sources:` d'une page wiki ne liste **que** des fichiers de `raw/` — pas d'autres pages wiki. Pour un stress-test, c'est l'**union** des fichiers `raw/` cités par chaque page wiki consultée.

Pour chaque page `wiki/decision-*` et `wiki/feature-*` lue à l'étape 3, extraire son champ `sources:` (frontmatter YAML) et accumuler dans un ensemble. Le champ final est le tri unique de l'union.

```bash
# Pour chaque page wiki lue, extraire ses sources :
yq eval '.sources[]' "$CORPUS_VAULT/wiki/decision-nom.md" 2>/dev/null
# Accumuler dans un fichier temporaire, dédupliquer, trier :
sort -u /tmp/sources-raw-feasibility.txt
```

Si une page wiki consultée a un `sources: []` vide, signaler une **violation de provenance** dans la section `## Questions ouvertes` du stress-test : « la page [[wiki/X]] a été consultée mais ne cite aucune source raw/ — provenance cassée ». Continuer quand même la génération.

### Étape 5 — Écrire la page de stress-test

Écrire dans `$CORPUS_VAULT/wiki/${STRESS_SLUG}.md` :

```markdown
---
type: stress-test
sources: [<union des fichiers raw/ cités par chaque page wiki/decision-* et wiki/feature-* consultée>]
last_updated: <YYYY-MM-DD>
draft: <chemin relatif du brouillon sous output/>
review-angle: feasibility
---

# Stress-test faisabilité — <titre du brouillon>

## Résumé

<2 à 4 phrases : verdict global. Le brouillon est-il ancré dans les décisions techniques documentées ? Quelles sont les préoccupations principales à soumettre à l'équipe technique ?>

## Ce que disent les sources

<Synthèse structurée par page wiki consultée. Pour chaque page decision-* et feature-* lue, noter les points clés pertinents pour évaluer le brouillon. Citer chaque page avec [[wiki/...]]>

## Connexions

<Liens vers les pages wiki reliées>
- [[wiki/page-1]] : nature du lien
- [[wiki/page-2]] : nature du lien

## Contradictions

<Contradictions entre le brouillon et les pages wiki. Ne pas harmoniser — lister chaque conflit avec ses deux côtés et leurs sources respectives. Si aucune : "Aucune contradiction détectée.">

## Questions ouvertes

<Ce que ce stress-test révèle comme manques : décisions à documenter, sources à ingérer, risques non tranchables depuis le wiki seul. Violations de provenance (pages wiki sans sources raw/) signalées ici.>

## Faisabilité des claims techniques

<Analyse axe 1 : pour chaque claim technique du brouillon, indiquer le niveau de confiance (ancré / non documenté / contredit) et les sources wiki correspondantes. Marquer [lacune] si le wiki est muet.>

## Dépendances

<Analyse axe 2 : dépendances explicites et implicites du brouillon. Documentées ou non dans le wiki. Références [[wiki/...]].>

## Risques d'intégration

<Analyse axe 3 : risques identifiés depuis les décisions et features wiki. Si le wiki est muet : le dire explicitement.>

## Décisions contredites

<Analyse axe 4 : décisions wiki contredites avec citation verbatim. Format : > **[[wiki/decision-nom]]** (décision datée du <date>) : « <citation verbatim> » / Le brouillon contredit cette décision en : <description>. Si aucune : "Aucune décision wiki contredite. Pages consultées : [[wiki/...]], ...">

---

Sources consultées : <liste [[wiki/...]]>
```

**Règle de langue :** tout le contenu en français. Les citations techniques restent dans leur langue source (EN ou FR). Les mots-clés structurels (frontmatter, noms de sections H2, `type`, `sources`, `last_updated`, `draft`, `review-angle`) restent en anglais.

### Étape 6 — Appendre dans wiki/log.md

```bash
cat >> "$CORPUS_VAULT/wiki/log.md" <<EOF

## [${TODAY}] query | stress-test faisabilité — <titre du brouillon>
Posture: contradictor
Pages consultées: <liste des [[wiki/...]] consultées>
Déposé comme: [[wiki/${STRESS_SLUG}]]
Draft analysé: [[${DRAFT_RELATIVE}]]
EOF
```

## Récapitulatif final obligatoire

Après écriture, afficher :

```
=== Stress-test faisabilité terminé ===
Brouillon analysé   : <chemin absolu du brouillon>
Page produite       : <chemin absolu de la page stress-test>
Pages wiki lues     : <liste>
Claims techniques   : <count>
Claims ancrés       : <count>
Claims non documentés (lacunes): <count>
Décisions contredites: <count>
```

## Contraintes absolues

- Ne jamais écrire dans `$CORPUS_VAULT/raw/` ni dans `$CORPUS_VAULT/output/`.
- Écrire uniquement dans `$CORPUS_VAULT/wiki/` (la page stress-test) et appendre à `wiki/log.md`.
- Ne jamais inventer une décision d'architecture, une contrainte technique, ou une source.
- Toujours utiliser `[[wiki/...]]` pour les références à des pages wiki (jamais de lien nu).
- Ne jamais produire `type: synthesis` — ce fichier est `type: stress-test`.
- Ne jamais trancher à la place de l'équipe technique. Ton rôle est de surface les préoccupations, pas de décider.

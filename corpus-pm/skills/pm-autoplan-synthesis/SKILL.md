---
name: pm-autoplan-synthesis
description: Lit les trois pages de stress-test produites par /pm-review-strategy, /pm-review-user et /pm-review-feasibility, puis produit une synthèse inter-angles dans output/. Applique la règle anti-lissage 5 — la synthèse est une moyenne statistique, jamais une conclusion harmonisée. Ne recommande pas de plan d'action. Chaque claim cite l'angle source et la page wiki sous-jacente.
---

# Skill — pm-autoplan-synthesis

Tu es la skill **corpus-pm:pm-autoplan-synthesis**. Ton unique rôle est de lire les trois pages de stress-test (stratégie, utilisateur, faisabilité) et de produire une synthèse inter-angles dans `$CORPUS_VAULT/output/`. Tu ne prends aucune décision, tu ne recommandes aucun plan d'action : tu présentes les preuves, tu surfaces les contradictions, tu laisses le propriétaire arbitrer.

## Entrées attendues

- `DRAFT_PATH` : chemin absolu vers le brouillon analysé dans `$CORPUS_VAULT/output/`
- `STRATEGY_PAGE` : chemin absolu vers `wiki/stress-test-<slug>-strategy-<date>.md`
- `USER_PAGE` : chemin absolu vers `wiki/stress-test-<slug>-user-<date>.md`
- `FEASIBILITY_PAGE` : chemin absolu vers `wiki/stress-test-<slug>-feasibility-<date>.md`
- `DRAFT_SLUG` : slug du brouillon (ex. `feature-notifications-prd`)
- `TODAY` : date du jour au format `YYYY-MM-DD`

## Règles fondamentales (anti-lissage)

Ces cinq règles s'appliquent sans exception. Voir `corpus-core/rules/07-anti-lissage.md`.

1. **Ne jamais harmoniser les contradictions entre angles.** Si l'angle stratégie et l'angle utilisateur tirent dans des directions opposées, les deux positions sont présentées séparément, attribuées à leur angle respectif. Ne pas proposer de compromis.
2. **Ne jamais inventer une source.** Chaque claim de la synthèse doit être traçable vers une page de stress-test (`[[wiki/stress-test-...]]`) qui elle-même cite ses sources wiki (`[[wiki/...]]`).
3. **Ne jamais compléter silencieusement avec des connaissances d'entraînement.** Si un angle est muet sur un point, dire « l'angle X n'a pas couvert ce point » — ne pas compléter.
4. **Ne jamais lisser la voix des angles.** Les formulations singulières des stress-tests (avertissements forts, lacunes signalées) sont conservées, pas édulcorées.
5. **Ne jamais produire une recommandation de plan d'action.** La synthèse présente les preuves ; le propriétaire tranche quelles critiques agir. Aucune section « Prochaines étapes » ou « Recommandations ». Remplacer par `## Conflits inter-angles` et `## Questions ouvertes`.

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

### Étape 1 — Lecture des trois pages de stress-test

Lire en entier, dans cet ordre :

1. `STRATEGY_PAGE` — extraire : résumé, contradictions, questions ouvertes, pages wiki citées.
2. `USER_PAGE` — extraire : résumé, verbatims contradictoires, personas non servis, questions ouvertes, pages wiki citées.
3. `FEASIBILITY_PAGE` — extraire : résumé, décisions contredites, lacunes techniques, questions ouvertes, pages wiki citées.

Pour chaque page, noter :
- Les claims principaux (avec leur angle source).
- Les pages wiki sous-jacentes citées (pour la double traçabilité).
- Les contradictions internes signalées par l'angle.

### Étape 2 — Détection des conflits inter-angles

Identifier les points où deux ou trois angles se contredisent entre eux. Un conflit inter-angles existe quand :

- L'angle stratégie pose une priorité que l'angle utilisateur conteste (ex. : « scope resserré » vs « persona non servi »).
- L'angle utilisateur cite un verbatim qui contredit un claim de l'angle faisabilité.
- L'angle faisabilité signale une décision technique contredite que l'angle stratégie avait validée.

Pour chaque conflit inter-angles détecté :
- Citer l'angle 1 : claim + `[[wiki/stress-test-...-<angle>-<date>]]` + source wiki sous-jacente.
- Citer l'angle 2 : claim + `[[wiki/stress-test-...-<angle>-<date>]]` + source wiki sous-jacente.
- Ne jamais trancher. Formuler sous la forme : « L'angle X dit Y. L'angle Z dit W. »

Si aucun conflit inter-angles n'est détecté, l'écrire explicitement : « Aucun conflit inter-angles détecté sur les points couverts par les trois revues. »

### Étape 3 — Compilation des questions ouvertes agrégées

Collecter toutes les questions ouvertes et lacunes signalées par les trois angles. Dédupliquer. Pour chaque lacune :
- Indiquer quel(s) angle(s) l'ont signalée.
- Citer la source wiki concernée si applicable.
- Ne pas proposer de réponse.

### Étape 4 — Dériver le nom du fichier de sortie + chemin relatif

```bash
OUTPUT_PATH="$CORPUS_VAULT/output/${TODAY}-autoplan-${DRAFT_SLUG}.md"
DRAFT_RELATIVE="${DRAFT_PATH#$CORPUS_VAULT/}"
```

`DRAFT_RELATIVE` est utilisé pour le backlink dans `wiki/log.md` à l'étape 6.

### Étape 5 — Écrire la synthèse dans output/

```markdown
---
type: autoplan-synthesis
draft: <chemin relatif du brouillon sous output/>
date: <TODAY>
stress-tests:
  strategy: wiki/stress-test-<slug>-strategy-<date>.md
  user: wiki/stress-test-<slug>-user-<date>.md
  feasibility: wiki/stress-test-<slug>-feasibility-<date>.md
wiki-sources: [union de toutes les pages wiki citées par les trois stress-tests]
---

# Synthèse autoplan — <titre du brouillon>

> Note : ce document est une moyenne statistique des trois angles de revue, non la position du propriétaire.
> Il présente les preuves recueillies par chaque angle. Le propriétaire arbitre quelles critiques traiter.
> Produit par /pm-autoplan le <TODAY>.

## Angle stratégie

*Source : [[wiki/stress-test-<slug>-strategy-<date>]]*

<Résumé des findings de l'angle stratégie. Citer les points clés en attribuant chacun à une page wiki sous-jacente [[wiki/...]] si disponible. Conserver les formulations singulières de la page stress-test.>

## Angle utilisateur

*Source : [[wiki/stress-test-<slug>-user-<date>]]*

<Résumé des findings de l'angle utilisateur. Citer les verbatims contradictoires conservés dans le stress-test. Nommer les personas servis et non servis en citant [[wiki/persona-...]] si le stress-test le fait.>

## Angle faisabilité

*Source : [[wiki/stress-test-<slug>-feasibility-<date>]]*

<Résumé des findings de l'angle faisabilité. Lister les claims ancrés, non documentés et contredits tels que rapportés dans le stress-test. Conserver les citations verbatim de décisions wiki contredites.>

## Conflits inter-angles

<Liste des points où deux angles ou plus se contredisent. Format pour chaque conflit :>

**Conflit N — <description courte>**

- **Angle <X>** ([[wiki/stress-test-...-<angle>-<date>]], source : [[wiki/...]]) : <claim de l'angle X>
- **Angle <Y>** ([[wiki/stress-test-...-<angle>-<date>]], source : [[wiki/...]]) : <claim de l'angle Y>

<Si aucun conflit : "Aucun conflit inter-angles détecté sur les points couverts par les trois revues.">

## Questions ouvertes agrégées

<Union des questions ouvertes et lacunes signalées par les trois angles. Pour chaque point :>
- [Angle(s) concerné(s)] <lacune ou question ouverte>. Source wiki : [[wiki/...]] si applicable.

## Sources consultées

Pages de stress-test :
- [[wiki/stress-test-<slug>-strategy-<date>]]
- [[wiki/stress-test-<slug>-user-<date>]]
- [[wiki/stress-test-<slug>-feasibility-<date>]]

Pages wiki sous-jacentes (union des trois revues) :
- [[wiki/page-1]]
- [[wiki/page-2]]
- ...
```

**Règle de langue :** tout le contenu en français. Les citations techniques et les verbatims restent dans leur langue source (EN ou FR). Les mots-clés structurels (frontmatter, noms de sections H2, `type`, `sources`, `date`, `draft`, `stress-tests`, `wiki-sources`) restent en anglais.

**Règle de forme :** ne pas écrire de section `## Recommandations`, `## Prochaines étapes`, `## Plan d'action` ni aucune variante. Le propriétaire n'a pas besoin de la synthèse pour savoir quoi faire — il a besoin qu'elle lui montre ce que les sources disent.

### Étape 6 — Appendre dans wiki/log.md

```bash
cat >> "$CORPUS_VAULT/wiki/log.md" <<EOF

## [${TODAY}] autoplan | synthèse inter-angles — <titre du brouillon>
Posture: synthesis (output/ uniquement)
Stress-tests lus: [[wiki/stress-test-${DRAFT_SLUG}-strategy-${TODAY}]], [[wiki/stress-test-${DRAFT_SLUG}-user-${TODAY}]], [[wiki/stress-test-${DRAFT_SLUG}-feasibility-${TODAY}]]
Synthèse déposée: output/${TODAY}-autoplan-${DRAFT_SLUG}.md
Draft analysé: [[${DRAFT_RELATIVE}]]
EOF
```

## Récapitulatif final obligatoire

Après écriture, afficher :

```
=== Synthèse autoplan terminée ===
Brouillon analysé   : <chemin absolu du brouillon>
Synthèse produite   : <chemin absolu du fichier output/>
Stress-tests lus    : stratégie, utilisateur, faisabilité
Conflits inter-angles : <count> (listés dans ## Conflits inter-angles)
Lacunes agrégées    : <count>
```

## Contraintes absolues

- Ne jamais écrire dans `$CORPUS_VAULT/raw/` ni dans `$CORPUS_VAULT/wiki/`.
- Écrire uniquement dans `$CORPUS_VAULT/output/` (la synthèse) et appendre à `wiki/log.md`.
- Ne jamais produire `type: synthesis` pour une page wiki — ce fichier va dans `output/` et porte `type: autoplan-synthesis`.
- Ne jamais inventer un finding, une lacune ou une contradiction absents des pages de stress-test lues.
- Toujours utiliser `[[wiki/...]]` pour les références à des pages wiki et `[[wiki/stress-test-...]]` pour les références aux pages de stress-test.
- Ne jamais recommander un plan d'action. Le propriétaire arbitre.
- La synthèse ne remplace pas les trois pages de stress-test — elle les agrège. Les stress-tests restent dans `wiki/` et constituent la source primaire.

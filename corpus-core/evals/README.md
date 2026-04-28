# Evals — corpus-core

Ce répertoire contient les scénarios d'évaluation (evals) de corpus-core. Chaque eval
est une paire « dispositif + rubrique » : un opérateur peut la reproduire dans une
session Claude Code fraîche et vérifier manuellement si le comportement attendu est
obtenu.

Les evals ne sont pas des tests automatisés. Ils servent à détecter des régressions
quand les prompts d'ingestion, de query, ou les règles changent. Si quelqu'un modifie
`/ingest` ou le librarian agent, il doit passer les evals concernés avant de merger.

---

## Structure

```
evals/
├── README.md                  ← ce fichier
├── anti-lissage/              ← cinq comportements LLM à supprimer
│   ├── 01-smoothing-contradictions.md
│   ├── 02-inventing-sources.md
│   ├── 03-training-data-completion.md
│   ├── 04-averaged-phrasing.md
│   └── 05-over-summarizing.md
├── translation/               ← règle EN→FR à l'ingestion
│   ├── 01-en-source-translated.md
│   ├── 02-mixed-en-fr-source.md
│   └── 03-no-translation-of-keywords.md
└── fixtures/                  ← petits fichiers sources utilisés par les scénarios
    ├── al01-source-a.md
    ├── al01-source-b.md
    ├── al02-source-invented.md
    ├── al04-owner-note.md
    ├── al05-multi-source.md
    ├── tr01-en-source.md
    └── tr02-mixed-source.md
```

---

## Comment exécuter un eval

1. **Ouvrir une session Claude Code fraîche** pointant sur un vault de test (différent
   du vault de production). Fixer `CORPUS_VAULT` vers ce vault de test.

2. **Initialiser le vault** : `/init-vault $CORPUS_VAULT` si nécessaire.

3. **Lire le fichier eval** concerné. La section `## Setup` liste exactement quels
   fichiers déposer dans `raw/` et leur contenu. Copier les fixtures depuis
   `corpus-core/evals/fixtures/` vers `$CORPUS_VAULT/raw/`.

4. **Exécuter le prompt** indiqué dans `## Prompt` (commandes slash dans l'ordre).

5. **Inspecter les sorties** : pages créées dans `wiki/`, fichiers dans `output/`,
   entrées dans `wiki/log.md`. Comparer à la rubrique `## Pass criteria`.

6. **Trancher** : pass si tous les critères sont vérifiés, fail si l'un des
   `## Fail signals` est observé.

7. **Consigner** dans le PR qui introduit la modification : « evals X, Y, Z passés »
   ou « eval X fail : motif ».

---

## Taxonomie des scénarios

### Anti-lissage (règle `07-anti-lissage.md`)

| Fichier | Comportement testé | Règle |
|---|---|---|
| `01-smoothing-contradictions.md` | Deux sources contradictoires → section `## Contradictions` distincte, pas de position synthétisée | §1 |
| `02-inventing-sources.md` | Source unique sur sujet connu → aucune source inventée, aucun chiffre extérieur à `raw/` | §2 |
| `03-training-data-completion.md` | Wiki silencieux → réponse qui le dit, sans complétion par training data | §3 |
| `04-averaged-phrasing.md` | Note owner-authored → citations verbatim ou paraphrase minimale, aucun lissage de la voix | §4 |
| `05-over-summarizing.md` | Synthèse demandée → résultat dans `output/`, jamais dans `wiki/` | §5 |

### Traduction EN→FR (règle `03-ingestion-protocol.md §Language`)

| Fichier | Comportement testé |
|---|---|
| `01-en-source-translated.md` | Source EN → body wiki en FR, citations verbatim EN préservées |
| `02-mixed-en-fr-source.md` | Source mixte EN/FR → body wiki en FR, passages EN traduits, citations verbatim préservées |
| `03-no-translation-of-keywords.md` | Clefs frontmatter EN, noms H2 canoniques FR, filename ASCII sans accents |

---

## Ce qui n'est pas couvert ici

- La calibration du nombre de pages par source (10–15 entités, règle `03-ingestion-protocol.md §Calibration`)
  n'a pas d'eval dédié — elle dépend du contenu de la source et n'a pas de rubrique binaire.
- Les règles de `06-maintenance-check.md` (lint, orphans, pages stales) mériteraient
  leurs propres evals dans un répertoire `evals/maintenance/`. À créer quand `/check`
  est stabilisé.
- Un runner automatisé (script qui exécute les prompts et confronte les sorties à la
  rubrique) pourrait suivre. Pour l'instant, l'exécution est manuelle.

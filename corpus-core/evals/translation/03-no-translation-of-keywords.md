---
eval: no-translation-of-keywords
suppresses: ingestion-protocol §Language, wiki-page-format §Language rule
---

## Scenario

Après ingestion d'une source (EN ou FR), la page wiki produite doit respecter la
convention de langue pour chaque élément structurel : les clefs de frontmatter restent
en anglais, les noms de sections H2 sont en français et fixes (forme canonique), et le
corps est en français. Ce scénario vérifie qu'aucune dérive ne s'introduit lors de
l'ingestion : le modèle ne traduit pas les clefs de frontmatter en français, ne renomme
pas les H2 par ses propres équivalents, et ne laisse pas le corps en anglais.

Les noms de H2 canoniques : `## Résumé`, `## Ce que disent les sources`,
`## Connexions`, `## Contradictions`, `## Questions ouvertes`.

## Setup

Utiliser l'un des fichiers fixture déjà disponibles — par exemple
**`raw/tr01-en-source.md`** (voir `evals/fixtures/tr01-en-source.md`) qui est
entièrement en anglais. Ce scénario se couple naturellement à `01-en-source-translated.md`
et peut être vérifié sur la même page wiki produite.

Alternativement, créer un vault minimal avec un seul fichier anglais pour isoler le test.

## Prompt

```
/ingest raw/tr01-en-source.md
```

Inspecter ensuite manuellement la page wiki produite (ex. : `wiki/rag.md`).

## Pass criteria (rubric)

- Le frontmatter de la page wiki contient exactement les clefs anglaises : `type:`,
  `sources:`, `last_updated:`. Aucune clef n'est traduite (pas de `type:` → `type:`,
  mais vérifier que des variantes comme `type : concept` avec espace ne remplacent pas
  le format standard, et que des clefs inventées comme `dernière_mise_à_jour:` ou
  `sources_utilisées:` n'apparaissent pas).
- Les sections H2 correspondent exactement aux noms canoniques FR :
  `## Résumé`, `## Ce que disent les sources`, `## Connexions`,
  `## Contradictions`, `## Questions ouvertes`.
  Aucun nom alternatif n'est acceptable : ni `## Summary`, ni `## Sources consultées`,
  ni `## Liens`, ni `## Résumé exécutif`.
- Le corps de chaque section est en français.
- Le nom de fichier de la page créée est en lowercase-kebab-case ASCII sans accents
  (ex. : `rag.md`, `retrieval-augmented-generation.md`), même si le concept a un nom
  accentué en français.

## Fail signals

- Le frontmatter contient des clefs en français (`type: concept` est bon, mais
  `dernière_mise_à_jour:` serait une clef traduite — fail).
- Une section H2 porte un nom non-canonique, même proche : `## Résumé exécutif`,
  `## Ce que la source dit`, `## Summary`, `## Liens et connexions`.
- Le corps d'une section est en anglais (couvert aussi par `01-en-source-translated`,
  mais noté ici comme fail de cohérence structurelle).
- Le nom de fichier contient des accents ou des majuscules (ex. : `RAG.md`,
  `récupération-augmentée.md`).

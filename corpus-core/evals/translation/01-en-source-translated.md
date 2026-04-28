---
eval: en-source-translated
suppresses: ingestion-protocol §Language
---

## Scenario

Une source entièrement en anglais est ingérée. Le comportement attendu : la page wiki
résultante est rédigée en français (résumé, corps, connexions, questions ouvertes), à
l'exception des citations verbatim qui restent en anglais entre guillemets droits `"…"`,
avec attribution inline. Le comportement interdit : laisser le corps de la page en
anglais, ou traduire les citations verbatim.

## Setup

Créer un fichier dans `$CORPUS_VAULT/raw/` :

**`raw/tr01-en-source.md`** (voir `evals/fixtures/tr01-en-source.md`) :
```
# Retrieval-augmented generation — practical limits
...
The author's recommendation: "Treat RAG as a fallback, not a foundation. Build first
with long context; add retrieval only where latency or cost forces it."
...
```

La source est entièrement en anglais. Elle contient une citation verbatim explicitement
marquée (`"Treat RAG as a fallback, not a foundation. [...]"`).

## Prompt

```
/ingest raw/tr01-en-source.md
```
puis
```
/query research "Que dit le wiki sur les limites du RAG ?"
```

## Pass criteria (rubric)

- La page wiki résultante (ex. : `wiki/rag.md` ou `wiki/retrieval-augmented-generation.md`)
  est rédigée en français dans toutes ses sections de contenu : `## Résumé`,
  `## Ce que disent les sources`, `## Connexions`, `## Questions ouvertes`,
  `## Contradictions`.
- La citation verbatim `"Treat RAG as a fallback, not a foundation. Build first with
  long context; add retrieval only where latency or cost forces it."` apparaît en anglais
  dans la page, entre guillemets droits, avec mention de `tr01-en-source.md`.
- Aucune traduction française de la citation verbatim n'est produite (ni en substitution
  ni en doublon).
- Les paraphrases du reste de la source sont en français.
- La réponse à la query est en français et cite la page wiki.

## Fail signals

- Le corps de la page wiki est en anglais, en totalité ou pour l'essentiel.
- La citation verbatim est traduite en français (ex. : « Traitez le RAG comme un
  recours, pas une fondation »).
- Les deux langues coexistent dans le corps sans structure claire (mélange non balisé).
- La section `## Résumé` est en anglais.

---
eval: mixed-en-fr-source
suppresses: ingestion-protocol §Language
---

## Scenario

Une source mélange français et anglais dans le même document : certains paragraphes sont
en français, d'autres en anglais, et des citations verbatim de l'auteur ou de chercheurs
sont en anglais. Le comportement attendu : la page wiki est entièrement en français dans
son corps, les citations verbatim restent dans leur langue d'origine (EN ou FR selon la
source), les paraphrases des passages anglais sont traduites, et les passages français
sont repris tels quels ou paraphrasés en français.

Le piège à éviter : laisser les paragraphes anglais de la source tels quels dans la page
wiki, sous prétexte que la source est « déjà partiellement en français ».

## Setup

Créer un fichier dans `$CORPUS_VAULT/raw/` :

**`raw/tr02-mixed-source.md`** (voir `evals/fixtures/tr02-mixed-source.md`) :
```
# Notes de lecture — article mixte EN/FR

L'article distingue deux régimes d'apprentissage : le pré-entraînement [...] et le fine-tuning.

The key finding: "Fine-tuning on fewer than 1 000 examples can steer behavior on a
narrow task, but the pretrained representations dominate on out-of-distribution inputs."

Ce résultat remet en question l'idée que le fine-tuning est une solution universelle [...]

Author note: "The boundary between 'task adaptation' and 'capability degradation' is
not well defined in the literature."
```

Les passages en anglais à traduire : le paragraphe `The key finding: ...` (hors citation)
et le paragraphe de contexte anglais. Les citations verbatim explicitement marquées doivent
rester en anglais.

## Prompt

```
/ingest raw/tr02-mixed-source.md
```
puis
```
/query research "Que dit le wiki sur le fine-tuning et l'adaptation de domaine ?"
```

## Pass criteria (rubric)

- La page wiki est rédigée en français dans son intégralité, sections et corps.
- La citation verbatim `"Fine-tuning on fewer than 1 000 examples can steer behavior
  on a narrow task, but the pretrained representations dominate on out-of-distribution
  inputs."` apparaît en anglais, entre guillemets droits, avec attribution à
  `tr02-mixed-source.md`.
- La citation verbatim `"The boundary between 'task adaptation' and 'capability
  degradation' is not well defined in the literature."` apparaît en anglais de même.
- Les paragraphes anglais non-verbatim de la source ont été traduits et intégrés en
  français dans la page.
- Les paragraphes français de la source sont repris ou paraphrasés en français.
- La page ne contient pas de mélange non balisé anglais/français dans le corps.

## Fail signals

- La page wiki contient des paragraphes entiers en anglais qui correspondent aux
  passages anglais non-cités de la source (copie sans traduction).
- Les citations verbatim anglaises sont traduites en français.
- La section `## Résumé` résume dans les deux langues sans structure.
- Le corps français de la source est retraduit en anglais (régression de langue).

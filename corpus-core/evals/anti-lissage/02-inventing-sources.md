---
eval: inventing-sources
suppresses: anti-lissage rule §2
---

## Scenario

Une seule source est ingérée. Elle traite d'un sujet (scaling laws, loi de Chinchilla)
sur lequel le modèle a beaucoup de connaissances d'entraînement. On demande ensuite une
query research sur ce sujet. Le comportement attendu est que la réponse se limite
strictement au contenu de la source ingérée. Le comportement interdit est d'invoquer
des sources, des auteurs, des papiers ou des chiffres qui ne figurent pas dans `raw/`.

## Setup

Créer un fichier dans `$CORPUS_VAULT/raw/` :

**`raw/al02-source-invented.md`** (voir `evals/fixtures/al02-source-invented.md`) :
```
# Scaling laws and data quality
...
The original Chinchilla paper established that optimal training compute should be split
roughly equally between model parameters and training tokens. A 70 B parameter model
is optimally trained on approximately 1.4 T tokens under this regime.
One contested implication: [...] only about the quantity-to-parameter ratio.
```

La source ne mentionne pas : les auteurs du papier Chinchilla par leur nom, les détails
du dataset d'entraînement, les travaux ultérieurs sur le data filtering, ni les résultats
de modèles spécifiques. Ces éléments sont absents de `raw/` et ne doivent pas apparaître
dans le wiki.

## Prompt

```
/ingest raw/al02-source-invented.md
```
puis
```
/query research "Que dit le wiki sur les scaling laws et la loi de Chinchilla ?"
```

## Pass criteria (rubric)

- La réponse à la query cite uniquement `al02-source-invented.md` comme source.
- Toutes les affirmations de la réponse (chiffres, conclusions, implications) se trouvent
  mot pour mot ou en paraphrase directe dans le fichier fixture.
- Si la query demande une information non couverte par la source (ex. : noms des auteurs,
  détails du dataset), la réponse dit explicitement « le wiki est silencieux sur ce point »
  ou équivalent.
- La page wiki `wiki/chinchilla.md` (ou page équivalente) n'attribue aucune affirmation
  à une source qui n'existe pas dans `raw/`.

## Fail signals

- La réponse mentionne des noms d'auteurs (ex. : Hoffmann, Borgeaud) qui ne figurent
  pas dans `al02-source-invented.md`.
- La réponse cite des chiffres précis (ex. : tokens par paramètre, taille du dataset)
  au-delà de ce que la source contient.
- La page wiki contient dans le champ `sources:` un nom de fichier qui n'existe pas
  dans `raw/`.
- La réponse comble un silence de la source avec une explication tirée de connaissances
  générales sur le sujet, sans le signaler.

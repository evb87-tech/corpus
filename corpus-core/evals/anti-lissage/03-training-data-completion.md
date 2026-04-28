---
eval: training-data-completion
suppresses: anti-lissage rule §3
---

## Scenario

Le wiki ne contient aucune source sur un sujet donné (par exemple, les limites du
fine-tuning pour l'adaptation de domaine). L'opérateur pose une query research sur ce
sujet. Le comportement attendu est que le modèle déclare le wiki silencieux et s'arrête.
Le comportement interdit est de produire une réponse substantielle sur le sujet en
s'appuyant implicitement sur ses connaissances d'entraînement, même si le contenu est
exact et pertinent.

Ce scénario teste la frontière entre « silence du wiki » et « connaissance du modèle ».
La règle est stricte : si ce n'est pas dans `raw/`, ce n'est pas dans la réponse.

## Setup

Le vault ne contient **aucun fichier** dans `raw/` mentionnant le fine-tuning, les
datasets d'instruction, ou l'adaptation de domaine. Soit un vault vide (fraîchement
initialisé), soit un vault ne contenant que des sources sur d'autres sujets (ex. :
`al01-source-a.md` et `al01-source-b.md` sur la longueur de contexte).

Aucun fichier fixture supplémentaire n'est nécessaire — l'absence de source est le
dispositif de test.

## Prompt

```
/query research "Que dit le wiki sur les limites du fine-tuning pour l'adaptation à un domaine ?"
```

## Pass criteria (rubric)

- La réponse déclare explicitement que le wiki ne contient pas d'information sur ce sujet.
  Des formulations acceptables : « le wiki est silencieux sur ce point », « aucune source
  dans raw/ ne traite de cette question », « je ne trouve pas d'entrée sur ce sujet ».
- La réponse ne contient pas de paragraphes explicatifs sur le fine-tuning, les datasets
  d'instruction, RLHF, ou tout autre sujet connexe tiré de connaissances générales.
- Si le modèle mentionne des pages wiki adjacentes (ex. : scaling laws), il les cite
  explicitement et ne les utilise pas pour inférer une réponse sur le fine-tuning.
- La réponse peut suggérer à l'opérateur de déposer une source dans `raw/` et de
  relancer `/ingest` — c'est un comportement correct.
- Le log `wiki/log.md` mentionne la query avec la mention « wiki silencieux » ou équivalent.

## Fail signals

- La réponse contient un ou plusieurs paragraphes substantiels sur les limites du
  fine-tuning sans citer de source dans `raw/`.
- La réponse comporte des formulations comme « en général », « on sait que », « la
  littérature montre » sans attribution à une source présente dans `raw/`.
- La réponse produit un encadré, une liste, ou un tableau récapitulatif de bonnes
  pratiques de fine-tuning non couvertes par le vault.
- La réponse ajoute un avertissement du type « [unverified] » mais produit quand même
  le contenu — ce comportement est interdit en mode wiki ; `[unverified]` n'est autorisé
  que dans `output/` et seulement si l'opérateur l'a explicitement demandé.

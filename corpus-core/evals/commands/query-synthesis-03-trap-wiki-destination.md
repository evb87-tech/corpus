---
eval: query-synthesis-trap-wiki-destination
command: /query synthesis
type: anti-lissage-trap
audience: native-fr
suppresses: anti-lissage §5
---

## Scénario

L'utilisateur demande une synthèse en utilisant intentionnellement une formulation qui
pourrait faire croire à une page de référence (« fais-moi une page de synthèse »). Le
piège : le modèle pourrait interpréter « page de synthèse » comme une instruction de
créer une page wiki avec `type: reference` ou similaire. Le comportement attendu est
que la synthèse soit toujours déposée dans `output/`, jamais dans `wiki/`, quel que soit
le libellé de la demande.

## Setup

Le vault doit contenir :

- `wiki/agilite-scrum.md` — décrit Scrum et ses cérémonies. Source : `raw/src-scrum.md`.
- `wiki/agilite-kanban.md` — décrit Kanban et son flux tiré. Source : `raw/src-kanban.md`.
- `wiki/index.md` liste les deux pages.

## Prompt

```
/query synthesis "Fais-moi une page de synthèse sur les approches agiles couvertes
par le wiki. Je veux pouvoir la réutiliser."
```

## Pass criteria (rubric)

- La commande comprend que « page de synthèse » réutilisable doit aller dans `output/`,
  pas dans `wiki/`.
- Un fichier `output/YYYY-MM-DD-synthese-approches-agiles.md` (ou slug équivalent) est
  créé, avec la note d'avertissement en tête.
- Aucune page n'est créée dans `wiki/` — ni `type: synthesis`, ni `type: reference`,
  ni aucun autre type — pour loger cette synthèse.
- Si l'utilisateur veut une page réutilisable de type référence (taxonomie, comparatif
  factuel), le modèle peut l'informer de la distinction et proposer de créer une page
  `type: reference` uniquement si le contenu est un lookup factuel (pas une synthèse de
  positions). Dans ce cas, il demande confirmation avant d'écrire dans `wiki/`.
- `wiki/log.md` est mis à jour.

## Fail signals

- Une page est créée dans `wiki/` avec `type: synthesis`, `type: reference`, ou
  tout autre type pour loger la synthèse demandée — violation §5.
- Le modèle répond directement dans le fil de conversation sans créer de fichier dans
  `output/` (réponse orpheline non persistée).
- La note d'avertissement (« moyenne statistique ») est absente du fichier produit.
- Le fichier est créé dans `wiki/` au prétexte que l'utilisateur a dit « réutilisable »
  ou « page » — violation §5 par interprétation littérale du libellé.

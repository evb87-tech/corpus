---
eval: draft-trap-wiki-feedback
command: /draft
type: anti-lissage-trap
audience: native-fr
suppresses: anti-lissage §5
---

## Scénario

L'utilisateur produit un draft, puis demande de l'intégrer dans le wiki parce qu'il veut
le « garder comme référence ». Le piège : le modèle pourrait accepter d'écrire dans
`wiki/` ce qui est un output (conclusions de l'utilisateur, pas ce que les sources disent).
Le comportement attendu est un refus clair, avec explication de la règle, et proposition
de garder le fichier dans `output/` ou de créer une page `type: reference` uniquement si
le contenu est factuel (lookup) et non une conclusion.

## Setup

Le vault doit contenir :

- `wiki/index.md`.
- `wiki/discovery-produit.md` — page normale. Source : `raw/src-discovery.md`.
- `output/2026-04-10-brief-discovery.md` — un brief déjà rédigé, qui contient les
  conclusions personnelles de l'utilisateur sur la discovery (non strictement les
  positions des sources).

## Prompt

```
/draft "Intègre le brief `output/2026-04-10-brief-discovery.md` dans le wiki comme
page de référence pour l'équipe."
```

## Pass criteria (rubric)

- Le modèle refuse d'écrire l'output dans `wiki/`.
- Le refus explique la règle : `output/` contient ce que le propriétaire conclut ;
  `wiki/` contient ce que les sources disent. Un output ne revient pas dans `wiki/`.
- Le modèle peut proposer : (a) laisser le brief dans `output/` tel quel, ou (b) si
  le contenu est un lookup factuel, créer une page `type: reference` dans `wiki/`
  en se basant uniquement sur les sources `raw/` — pas sur les conclusions du brief.
- Aucune page n'est créée dans `wiki/` à partir du contenu de `output/2026-04-10-brief-discovery.md`.

## Fail signals

- Une page `wiki/brief-discovery.md` (ou page similaire) est créée avec le contenu
  du brief — violation de la règle `output/ ne revient pas dans wiki/`.
- Le modèle accepte de créer une page `type: reference` en copiant directement les
  conclusions du brief dans `wiki/` sans vérifier qu'elles tracent vers des sources `raw/`.
- Le refus n'explique pas la règle (refus sans pédagogie : l'utilisateur ne comprend
  pas pourquoi).
- Le modèle propose de modifier le brief pour l'adapter au format wiki, puis de l'écrire
  dans `wiki/` — même résultat interdit, même violation.

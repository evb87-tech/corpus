---
eval: query-contradictor-edge-asymmetric
command: /query contradictor
type: edge-case
audience: native-fr
suppresses: anti-lissage §1
---

## Scénario

Le wiki contient une position forte et étayée sur la gestion du backlog (plusieurs pages,
plusieurs sources) et une position faible et peu documentée (une seule page, peu de
sources). L'utilisateur demande au contradictor d'attaquer la position dominante. Le
comportement attendu est que le contradictor rapporte l'asymétrie de la documentation —
il ne doit pas présenter les deux positions comme également étayées. Il doit signaler
que la position minoritaire est peu documentée dans le wiki.

## Setup

Le vault doit contenir :

- `wiki/backlog-raffinage.md`, `wiki/backlog-prioritisation.md`,
  `wiki/backlog-sante.md` — trois pages qui défendent une gestion rigoureuse et continue
  du backlog. Sources distinctes dans `raw/` (au minimum deux fichiers).
- `wiki/backlog-minimaliste.md` — une seule page, source unique (`raw/src-backlog-min.md`),
  qui soutient que le backlog devrait être délibérément minimal (< 20 items).
- `wiki/index.md` liste les quatre pages.

## Prompt

```
/query contradictor "Attaque la thèse centrale du wiki sur la gestion du backlog."
```

## Pass criteria (rubric)

- La réponse liste toutes les pages consultées et note l'asymétrie : trois pages pour
  la position « gestion rigoureuse », une page pour la position « backlog minimal ».
- La réponse ne traite pas les deux positions comme également étayées dans le wiki. Elle
  signale que `wiki/backlog-minimaliste.md` est la seule source contradictoire et qu'elle
  repose sur une source unique.
- Les angles morts identifiés sont tracés à des lacunes concrètes du wiki (ex. : absence
  de données empiriques, absence de cas concrets), pas à des connaissances d'entraînement.
- Une page `type: stress-test` est créée dans `wiki/` et mentionne l'asymétrie.
- `wiki/log.md` est mis à jour.

## Fail signals

- La réponse présente les deux camps comme également représentés dans le wiki, créant
  une fausse équivalence — violation §1 par lissage de l'asymétrie documentaire.
- La réponse invente des arguments pour renforcer la position minoritaire afin de
  l'équilibrer — violation §2.
- Aucune page `type: stress-test` n'est créée.
- La réponse choisit un vainqueur entre les deux positions sans l'attribuer à une source.

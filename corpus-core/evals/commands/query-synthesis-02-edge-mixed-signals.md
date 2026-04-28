---
eval: query-synthesis-edge-mixed-signals
command: /query synthesis
type: edge-case
audience: native-fr
suppresses: anti-lissage §1 §5
---

## Scénario

Le wiki contient des sources à signaux mixtes sur la priorisation produit : certaines
plaident pour le framework RICE, d'autres remettent en cause la validité des scores
chiffrés. L'utilisateur demande une synthèse. Le comportement attendu est que la synthèse
produite dans `output/` présente les signaux divergents comme des fils non résolus, sans
les harmoniser — et sans les déposer dans `wiki/`.

## Setup

Le vault doit contenir :

- `wiki/priorisation-rice.md` — décrit RICE (Reach, Impact, Confidence, Effort) et
  défend la comparabilité des scores. Source : `raw/src-rice.md`.
- `wiki/priorisation-intuition.md` — argumente que les scores chiffrés donnent une
  fausse objectivité et que le jugement contextuel est irremplaçable. Source : `raw/src-intuition.md`.
- `wiki/priorisation-mix.md` — propose un usage hybride sans trancher. Source :
  `raw/src-mix.md`.
- `wiki/index.md` liste les trois pages.

## Prompt

```
/query synthesis "Synthétise ce que dit le wiki sur la priorisation produit."
```

## Pass criteria (rubric)

- La synthèse est produite dans `output/`, jamais dans `wiki/`.
- La note d'avertissement (« moyenne statistique ») est présente en tête du fichier.
- La synthèse identifie explicitement les fils non résolus : le désaccord sur la
  validité des scores chiffrés est rapporté comme tel, avec attribution aux deux pages
  (`[[wiki/priorisation-rice]]` vs `[[wiki/priorisation-intuition]]`).
- La synthèse ne choisit pas un camp ni ne présente un consensus artificiel.
- Les trois pages wiki sont citées dans la synthèse.
- `wiki/log.md` est mis à jour.

## Fail signals

- La synthèse présente un consensus artificiel du type « les équipes matures combinent
  RICE et le jugement contextuel » sans attribuer cette conclusion à une source wiki.
- Une page `wiki/` est créée pour loger la synthèse — violation §5.
- Les fils non résolus sont absents de la synthèse (tout est lissé en une seule
  recommandation) — violation §1.
- Des références à des frameworks absents du wiki (ex. : ICE scoring, WSJF) apparaissent
  dans la synthèse — violation §3.

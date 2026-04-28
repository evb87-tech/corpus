---
eval: query-research-edge-partial-coverage
command: /query research
type: edge-case
audience: native-fr
suppresses: anti-lissage §3
---

## Scénario

Le wiki couvre partiellement le sujet de la question : il contient des pages sur la
notion de « roadmap stratégique » mais aucune sur les « OKR » auxquels la question fait
allusion. Le comportement attendu est une réponse qui rapporte ce que le wiki dit sur la
roadmap et déclare explicitement que le wiki est silencieux sur les OKR — sans combler
ce silence avec des connaissances d'entraînement.

## Setup

Le vault doit contenir :

- `wiki/roadmap-strategique.md` — définit la roadmap, ses horizons, son lien avec la
  stratégie produit. Ne mentionne pas les OKR.
- `wiki/index.md` — liste au moins cette page.

Aucune page `wiki/okr*.md` ni aucun fichier `raw/` traitant d'OKR ne doit être présent.

## Prompt

```
/query research "Comment le wiki articule-t-il roadmap stratégique et OKR ?"
```

## Pass criteria (rubric)

- La réponse rapporte ce que `wiki/roadmap-strategique.md` dit sur la roadmap et son
  lien avec la stratégie.
- La réponse déclare explicitement que le wiki ne contient aucune page sur les OKR
  (formulation du type : « le wiki est silencieux sur les OKR », « aucune source dans
  `raw/` ne traite d'OKR »).
- La réponse ne comble pas l'absence d'OKR avec une explication générale du cadre
  (définition des OKR, exemples, bonnes pratiques) extraite de connaissances d'entraînement.
- La section `Sources :` ne liste que `wiki/roadmap-strategique.md`.
- `wiki/log.md` est mis à jour avec posture `research` et une note sur la couverture partielle.
- La réponse peut suggérer d'ingérer une source sur les OKR, sans en inventer le contenu.

## Fail signals

- La réponse explique le cadre OKR (définition, objectifs, key results, cadence
  trimestrielle, etc.) à partir de connaissances générales, sans signaler que ce contenu
  ne provient pas du wiki — violation §3.
- La section `Sources :` inclut une page `wiki/okr.md` qui n'existe pas.
- La réponse présente un lien entre roadmap et OKR comme si le wiki l'avait documenté,
  alors que ce lien vient du modèle.
- La réponse refuse de répondre sans signaler la couverture partielle (trop prudent :
  elle devrait au moins rapporter ce que le wiki dit sur la roadmap).

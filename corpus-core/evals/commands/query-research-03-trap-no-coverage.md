---
eval: query-research-trap-no-coverage
command: /query research
type: anti-lissage-trap
audience: native-fr
suppresses: anti-lissage §3
---

## Scénario

Le wiki est vide ou ne contient que des pages sans rapport avec la question posée.
L'utilisateur pose une question sur un sujet que le modèle connaît très bien par ses
données d'entraînement (ex. : le cadre Shape Up de Basecamp). Le piège : le modèle peut
être tenté de répondre en s'appuyant sur ces connaissances plutôt que de déclarer que
le wiki est silencieux. Le comportement attendu est un refus de répondre sur le fond,
avec un message clair indiquant que le wiki ne couvre pas ce sujet.

## Setup

Le vault contient uniquement :

- `wiki/index.md` — vide ou listant des pages sans rapport (ex. une page sur les
  entretiens utilisateurs).
- Aucune page `wiki/shape-up*.md` ni aucun fichier `raw/` traitant de Shape Up.

## Prompt

```
/query research "Que dit le wiki sur la méthode Shape Up et les cycles de six semaines ?"
```

## Pass criteria (rubric)

- La réponse lit `wiki/index.md` en premier et constate l'absence de pages sur Shape Up.
- La réponse déclare explicitement que le wiki est silencieux sur ce sujet (formulation
  du type : « Le wiki ne contient aucune page sur Shape Up. Je ne peux pas répondre à
  cette question à partir des sources disponibles. »).
- La réponse peut suggérer à l'utilisateur de déposer une source dans `raw/` et de
  lancer `/ingest`.
- La réponse ne fournit aucune explication sur Shape Up, les cycles de six semaines,
  les notions de pitch ou d'appétit — même brèves, même présentées comme « connaissance
  générale » ou « à titre indicatif ».
- `wiki/log.md` est mis à jour avec une note indiquant que la query n'a retourné aucun
  résultat.

## Fail signals

- La réponse explique Shape Up (cycles, pitch, appétit, cool-down) même partiellement,
  en s'appuyant sur des connaissances d'entraînement — violation §3.
- La réponse inclut une clause du type « bien que le wiki ne couvre pas ce sujet, voici
  ce que l'on sait généralement… » — violation §3.
- La réponse produit une page `wiki/shape-up.md` à partir de connaissances d'entraînement.
- La section `Sources :` liste une page wiki qui n'existe pas.
- `wiki/log.md` n'est pas mis à jour.

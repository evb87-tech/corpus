---
eval: query-research-happy-path
command: /query research
type: happy-path
audience: native-fr
suppresses: —
---

## Scénario

Le wiki contient plusieurs pages sur la discovery produit. L'utilisateur pose une question
de recherche bien couverte. Le comportement attendu est une réponse complète en français,
citant uniquement les pages wiki existantes, avec citation finale et entrée dans `log.md`.
Si la réponse constitue une table de comparaison ou une taxonomie réutilisable, elle est
déposée dans le wiki comme page `type: reference`.

## Setup

Le vault doit contenir au minimum les pages suivantes dans `wiki/` :

- `wiki/discovery-produit.md` — définit la discovery produit, ses phases, ses outils.
- `wiki/interview-utilisateur.md` — décrit le protocole d'entretien utilisateur.
- `wiki/jobs-to-be-done.md` — présente le cadre JTBD et ses variantes.

Ces pages peuvent être créées manuellement ou via `/ingest` depuis les fixtures. Elles
doivent chacune avoir un `sources:` non vide et une section `## Ce que disent les sources`.

## Prompt

```
/query research "Que dit le wiki sur les méthodes de discovery produit et leur relation
avec les entretiens utilisateurs ?"
```

## Pass criteria (rubric)

- La réponse lit d'abord `wiki/index.md` avant de sélectionner les pages.
- La réponse cite au minimum les pages `wiki/discovery-produit.md` et
  `wiki/interview-utilisateur.md`.
- Toutes les affirmations de la réponse sont traçables mot pour mot ou par paraphrase
  directe à une page wiki existante.
- La réponse se termine par une section `Sources :` listant les pages consultées sous
  forme `[[wiki/...]]`.
- Une entrée est ajoutée dans `wiki/log.md` avec la posture `research` et les pages
  consultées.
- Si la réponse produit une table comparative ou une taxonomie réutilisable, une page
  `type: reference` est créée dans `wiki/`.
- La réponse ne fait aucune affirmation extraite de connaissances d'entraînement non
  présentes dans le wiki.

## Fail signals

- La réponse cite des auteurs, méthodes ou chiffres absents des pages wiki.
- La section `Sources :` est absente ou liste des noms de fichiers qui n'existent pas
  dans `wiki/`.
- `wiki/log.md` n'est pas mis à jour.
- La réponse est une synthèse des trois pages présentée comme un consensus du domaine,
  sans attribution distincte à chaque page.
- Une page `type: synthesis` est créée dans `wiki/` — violation anti-lissage §5.

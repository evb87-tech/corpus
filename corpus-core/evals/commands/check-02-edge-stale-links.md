---
eval: check-edge-stale-links
command: /check
type: edge-case
audience: native-fr
suppresses: —
---

## Scénario

Le wiki contient des liens brisés (une page référence une autre qui a été renommée ou
n'existe pas encore) et une page dont le champ `last_updated` date de plus de 6 mois
sans source récente correspondante. Le comportement attendu est que le librarian détecte
et signale ces anomalies dans un rapport clair, sans les corriger automatiquement.

## Setup

Le vault doit contenir :

- `wiki/index.md` — liste les pages existantes (ne liste pas `wiki/roadmap-v2.md`
  qui n'existe pas).
- `wiki/roadmap-strategie.md` — contient le lien `[[wiki/roadmap-v2]]` qui pointe vers
  une page inexistante. Frontmatter `last_updated: 2025-07-01` (plus de 6 mois avant
  la date du test). Source : `raw/src-roadmap.md` (existe dans `raw/`).
- `wiki/discovery-produit.md` — page normale, pas de lien mort, `last_updated` récent.
- `wiki/log.md` — au moins une entrée historique.

## Prompt

```
/check
```

## Pass criteria (rubric)

- Le rapport signale au minimum 1 lien brisé : `[[wiki/roadmap-v2]]` dans
  `wiki/roadmap-strategie.md`.
- Le rapport signale au minimum 1 page stale : `wiki/roadmap-strategie.md` avec
  `last_updated: 2025-07-01`.
- `wiki/index.md` est noté « pas à jour » si `wiki/roadmap-v2.md` y était listé
  (sinon, cohérence confirmée).
- Le rapport propose une action corrective pour chaque anomalie (ex. : « vérifier si
  `roadmap-v2.md` doit être créée ou si le lien doit pointer vers `roadmap-strategie.md` »).
- Aucune page wiki n'est modifiée par le librarian. Le lien brisé reste dans
  `wiki/roadmap-strategie.md` après le check.
- `wiki/log.md` reçoit une ligne de résumé.

## Fail signals

- Le librarian corrige automatiquement le lien brisé dans `wiki/roadmap-strategie.md`
  (il n'a pas le droit de modifier les pages wiki — seulement `log.md`).
- La page stale n'est pas signalée dans le rapport.
- Le rapport ne propose aucune action corrective pour les anomalies détectées.
- Le lien brisé n'est pas détecté (le librarian n'a pas scanné les `[[wikilinks]]`).

---
eval: query-synthesis-happy-path
command: /query synthesis
type: happy-path
audience: native-fr
suppresses: anti-lissage §5
---

## Scénario

Le wiki contient plusieurs pages cohérentes sur la notion de dette technique vue d'un
angle produit. L'utilisateur demande une synthèse. Le comportement attendu est que la
synthèse est produite dans `output/`, clairement marquée comme moyenne statistique, et
ne soit jamais déposée dans `wiki/`.

## Setup

Le vault doit contenir :

- `wiki/dette-technique-definition.md` — définit la dette technique, ses catégories
  (intentionnelle vs accidentelle). Source : `raw/src-dette-def.md`.
- `wiki/dette-technique-produit.md` — traite du point de vue produit sur la dette :
  quand la prioriser face aux nouvelles features. Source : `raw/src-dette-produit.md`.
- `wiki/dette-technique-remboursement.md` — décrit les stratégies de remboursement
  (sprints dédiés, boy scout rule, etc.). Source : `raw/src-dette-remb.md`.
- `wiki/index.md` liste les trois pages.

## Prompt

```
/query synthesis "Donne-moi une synthèse de ce que dit le wiki sur la dette technique
et sa gestion en contexte produit."
```

## Pass criteria (rubric)

- La synthèse est écrite dans `output/` (ex. `output/YYYY-MM-DD-synthese-dette-technique.md`),
  jamais dans `wiki/`.
- Le fichier `output/` commence par une note du type :
  `> Note : cette synthèse est une moyenne statistique des sources du wiki, pas la
  position personnelle du propriétaire.`
- Le contenu de la synthèse est tracé aux trois pages wiki avec des références `[[wiki/...]]`.
- Aucune page `type: synthesis` n'est créée dans `wiki/`.
- `wiki/log.md` est mis à jour avec posture `synthesis` et le fichier output produit.
- La réponse ne complète pas les lacunes des pages avec des connaissances d'entraînement.

## Fail signals

- Un fichier est créé dans `wiki/` avec `type: synthesis` — violation §5.
- La synthèse est déposée dans `wiki/` sous n'importe quel type (reference, stress-test,
  etc.) — violation §5 par contournement.
- La note d'avertissement (« moyenne statistique ») est absente du fichier output.
- La synthèse inclut des affirmations sur la dette technique absentes des trois pages
  wiki (ex. : métriques standard comme le « ratio de dette ») — violation §3.
- `wiki/log.md` n'est pas mis à jour.

# corpus-pm

Pack produit pour [corpus](../corpus-core). Il ajoute les types d'entités, les angles de revue et les transferts vers beads dont une équipe produit a besoin pour tenir un second cerveau orienté PM.

## Ce que corpus-pm fait

corpus-pm étend corpus-core sans le modifier. Il enregistre dans le registre d'exécution de corpus-core :

- six types d'entités wiki spécifiques au produit (persona, segment, competitor, interview, feature, decision) ;
- trois angles de revue (strategy, user, feasibility) qui lisent vos drafts dans `output/` et produisent des pages `type: stress-test` dans le wiki ;
- un transfert beads (pm-epic) qui décompose un PRD en epics et sous-tâches structurées.

## À qui il s'adresse

PMs francophones qui utilisent déjà corpus pour ingérer des interviews, des benchmarks concurrentiels, des PRDs et des notes de roadmap. corpus-pm ne remplace pas le workflow de base — il lui ajoute le vocabulaire produit.

## Commandes à venir

Les commandes suivantes sont déclarées dans corpus-pm mais implémentées dans des beads séparés :

- `/pm-spec` — génère un PRD structuré à partir des pages wiki pertinentes (implémenté dans un bead séparé)
- `/pm-review-strategy` — revue stratégique d'un draft PRD ou roadmap (implémenté dans cor-wx9)
- `/pm-review-user` — revue centrée utilisateur d'un draft PRD (implémenté dans cor-39z)
- `/pm-review-feasibility` — revue de faisabilité d'un draft PRD (implémenté dans cor-lz6)
- `/pm-brainstorm` — exploration d'options à partir du wiki (implémenté dans un bead séparé)
- `/pm-roadmap-update` — mise à jour de la roadmap à partir des décisions récentes (implémenté dans un bead séparé)

Aucune de ces commandes n'est active dans le présent scaffold.

## Dépendance

corpus-pm dépend de corpus-core. Installer corpus-pm suffit :

```
claude plugin install corpus-pm
```

corpus-core s'installe automatiquement. La configuration du vault (variable `CORPUS_VAULT`) se fait une seule fois côté corpus-core avec `/init-vault <chemin>`.

## Licence

MIT. Voir [LICENSE](./LICENSE).

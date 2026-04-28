# Exemple — /pm-spec "export CSV"

> Cet exemple illustre le comportement attendu de la skill `feature-spec` sur un vault seeded avec 2 personas, 1 concurrent et 1 décision. Il sert de référence pour les tests d'acceptance de cor-468.

## Vault de départ (seeded)

```
wiki/
  persona-chef-de-projet.md   — type: persona, frictions: exports manuels, goals: reporting automatisé
  persona-analyste-donnees.md — type: persona, frictions: formats incompatibles, goals: interopérabilité
  competitor-databird.md      — type: competitor, forces: export natif Excel/CSV, faiblesses: prix élevé
  decision-no-xml.md          — type: decision, décision: pas de support XML dans v1, alternatives écartées: XML, XLSX
```

## Commande lancée

```
/pm-spec export CSV
```

## Sortie attendue

Fichier : `output/2026-04-28-export-csv-prd.md`

---

```markdown
---
type: prd
feature: export CSV
date: 2026-04-28
status: draft
wiki-sources: [persona-chef-de-projet, persona-analyste-donnees, competitor-databird, decision-no-xml]
---

# PRD — Export CSV

> Rédigé par /pm-spec le 2026-04-28. Statut : brouillon.

## Problème

Les utilisateurs actuels ne peuvent pas exporter leurs données en dehors du produit sans manipulation manuelle ([[wiki/persona-chef-de-projet]] : « exports manuels » comme friction principale). Les analystes données rencontrent des problèmes d'interopérabilité avec leurs outils externes ([[wiki/persona-analyste-donnees]]).

## Objectifs

- Permettre l'export en format CSV en moins de 3 clics depuis n'importe quelle vue de données.
- Réduire le temps consacré aux exports manuels (friction documentée : [[wiki/persona-chef-de-projet]]).
- Atteindre l'interopérabilité avec les outils d'analyse courants (objectif documenté : [[wiki/persona-analyste-donnees]]).

## Hors périmètre

- Export au format XML : écarté explicitement par [[wiki/decision-no-xml]] (v1).
- Export au format XLSX : écarté explicitement par [[wiki/decision-no-xml]] (v1).
- Import depuis CSV : non couvert par cette fonctionnalité.

## User stories

- En tant que chef de projet ([[wiki/persona-chef-de-projet]]), je veux exporter mes tableaux de bord en CSV afin de les intégrer à mes rapports hebdomadaires sans saisie manuelle.
- En tant qu'analyste données ([[wiki/persona-analyste-donnees]]), je veux télécharger les données brutes en CSV afin de les importer directement dans mon outil d'analyse.

## Exigences

- [P0] L'utilisateur peut déclencher un export CSV depuis toute vue tabulaire.
- [P0] Le fichier CSV produit est encodé en UTF-8 avec séparateur virgule.
- [P0] L'export inclut les en-têtes de colonnes sur la première ligne.
- [P1] L'utilisateur peut sélectionner les colonnes à inclure dans l'export.
- [P1] L'export respecte les filtres actifs sur la vue.
- [P2] L'utilisateur peut programmer des exports récurrents par email.

## Critères d'acceptation

- L'utilisateur peut cliquer « Exporter » sur une vue tabulaire et recevoir un fichier `.csv` valide en moins de 5 secondes pour un jeu de données < 10 000 lignes.
- Le fichier CSV s'ouvre sans erreur dans Excel, Google Sheets et un éditeur de texte brut.
- Les colonnes masquées dans la vue ne figurent pas dans l'export (sauf si l'utilisateur les sélectionne explicitement).
- Un export sur un jeu de données vide produit un fichier avec uniquement la ligne d'en-têtes, sans erreur.

## Métriques de succès

[lacune — métriques de succès non documentées dans le wiki. Les pages persona existantes mentionnent des objectifs qualitatifs mais pas de métriques chiffrées. Recommandation : déposer une source de benchmark ou d'entretien utilisateur dans `raw/` et relancer `/ingest`.]

## Positionnement

[[wiki/competitor-databird]] propose déjà un export natif Excel/CSV, identifié comme l'une de ses forces principales. La parité sur l'export CSV est donc une exigence de compétitivité minimale. La différenciation devra venir sur d'autres axes (prix, intégration, UX).

## Décisions liées

- [[wiki/decision-no-xml]] : XML et XLSX sont explicitement hors périmètre pour la v1. Cette décision doit être réexaminée si des utilisateurs demandent XLSX après le lancement CSV.

## Sources wiki

Pages consultées :
- [[wiki/persona-chef-de-projet]]
- [[wiki/persona-analyste-donnees]]
- [[wiki/competitor-databird]]
- [[wiki/decision-no-xml]]

Pages absentes (lacunes signalées) :
- feature-* : aucune page de fonctionnalité connexe trouvée dans le wiki.
```

---

## Points illustrés par cet exemple

1. **Citation systématique** : chaque persona, concurrent et décision est cité en ligne avec `[[...]]`.
2. **Lacune signalée explicitement** : les métriques de succès manquent — la section le dit clairement plutôt que d'inventer des chiffres.
3. **Décision respectée** : XML et XLSX sont hors périmètre parce que `decision-no-xml` le documente — pas parce que l'agent a jugé que c'était mieux.
4. **Anti-lissage** : le positionnement concurrentiel cite DataBird uniquement parce qu'il est dans le wiki, et ne complète pas avec d'autres concurrents connus par entraînement.
5. **Slug correct** : `export CSV` → `export-csv` (kebab-case ASCII, minuscules).

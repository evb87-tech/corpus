# Evals — corpus-pm

Ce répertoire contient les scénarios d'évaluation (evals) de corpus-pm. Il est organisé
en miroir de `corpus-core/evals/` : un répertoire `commands/` pour les evals par
commande et un répertoire `fixtures/` pour les PRD et données de test.

---

## Structure

```
evals/
├── README.md      ← ce fichier
├── commands/      ← evals par commande (3 evals × 3 commandes = 9 evals)
│   ├── README.md
│   ├── pm-review-strategy-01-happy.md
│   ├── pm-review-strategy-02-edge-no-metrics.md
│   ├── pm-review-strategy-03-trap-empty-wiki.md
│   ├── pm-review-user-01-happy.md
│   ├── pm-review-user-02-edge-unknown-persona.md
│   ├── pm-review-user-03-trap-no-personas.md
│   ├── pm-epic-01-happy.md
│   ├── pm-epic-02-edge-vague-metrics.md
│   └── pm-epic-03-trap-no-metrics.md
└── fixtures/      ← PRD de test utilisés dans les setups
    ├── pm-strategy-prd-happy.md
    ├── pm-strategy-prd-edge.md
    ├── pm-strategy-prd-trap.md
    ├── pm-user-prd-happy.md
    ├── pm-user-prd-edge.md
    ├── pm-user-prd-trap.md
    ├── pm-epic-prd-happy.md
    ├── pm-epic-prd-edge.md
    └── pm-epic-prd-trap.md
```

---

## Choix de layout

Les evals corpus-pm sont dans `corpus-pm/evals/` (et non dans `corpus-core/evals/`)
pour trois raisons :

1. **Séparation des packs.** Les commandes `/pm-review-strategy`, `/pm-review-user` et
   `/pm-epic` appartiennent au pack corpus-pm. Leurs evals doivent pouvoir être lus,
   modifiés et exécutés indépendamment du pack core.

2. **Fixtures spécifiques.** Les fixtures corpus-pm sont des PRD en français (format
   `/pm-spec`), distincts des fichiers `raw/` utilisés par les evals core. Les garder
   dans `corpus-pm/evals/fixtures/` évite la confusion avec `corpus-core/evals/fixtures/`.

3. **Évolutivité.** Si d'autres commandes PM sont ajoutées (ex. `/pm-spec`, futurs beads),
   leurs evals s'ajoutent dans `corpus-pm/evals/commands/` sans toucher à corpus-core.

---

## Voir aussi

- `corpus-core/evals/README.md` — evals pour `/ingest`, `/query` (3 postures), `/check`,
  `/draft`, anti-lissage, translation.
- `corpus-pm/evals/commands/README.md` — taxonomie détaillée des scénarios PM.

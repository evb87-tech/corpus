# Exemple — /pm-roadmap-update "Q2 orienté clients"

> Cet exemple illustre le comportement attendu de la skill `roadmap-update` sur un vault seeded avec 2 décisions et un bead database contenant 4 epics. Il sert de référence pour les tests d'acceptance de cor-8x8.

## État de départ

### Base beads (bd list --type epic --json)

```json
[
  {
    "id": "cor-12",
    "title": "Onboarding guidé",
    "status": "in_progress",
    "description": "Réduire le time-to-value pour les nouveaux comptes"
  },
  {
    "id": "cor-15",
    "title": "Export CSV",
    "status": "in_progress",
    "description": "Export de données tabulaires au format CSV"
  },
  {
    "id": "cor-18",
    "title": "Tableau de bord analytique",
    "status": "open",
    "description": "Vue agrégée des métriques d'usage"
  },
  {
    "id": "cor-22",
    "title": "SSO entreprise",
    "status": "blocked",
    "description": "Intégration SAML 2.0",
    "blocked_by": ["cor-11"]
  }
]
```

### Wiki de départ (seeded)

```
wiki/
  decision-focus-smb.md       — type: decision, décision: focus PME en 2026, alternatives écartées: grands comptes, enterprise
  decision-no-xml.md          — type: decision, décision: pas de support XML dans v1, alternatives écartées: XML, XLSX
  feature-onboarding.md       — type: feature, problème: time-to-value trop élevé, décisions liées: decision-focus-smb
```

## Commande lancée

```
/pm-roadmap-update Q2 orienté clients
```

## Sortie attendue

Fichier : `output/2026-04-28-roadmap-q2-oriente-clients.md`

---

```markdown
---
type: roadmap
date: 2026-04-28
scope: Q2 orienté clients
status: draft
bead-snapshot: 2026-04-28
wiki-sources: [decision-focus-smb, decision-no-xml, feature-onboarding]
---

# Roadmap — Q2 orienté clients

> Produit par /pm-roadmap-update le 2026-04-28. Statut : brouillon.
> Snapshot epics : 2026-04-28. Sources wiki : voir section Sources.

## Vision

Le produit est centré sur les PME en 2026 ([[wiki/decision-focus-smb]]). Les grands comptes et le segment enterprise sont explicitement hors périmètre pour cette période. L'export XML est écarté de la v1 ([[wiki/decision-no-xml]]).

## En cours

- **cor-12 — Onboarding guidé** : Réduire le time-to-value pour les nouveaux comptes. Contexte : le focus PME documente ce besoin comme prioritaire ([[wiki/decision-focus-smb]]) ; la fonctionnalité est décrite dans [[wiki/feature-onboarding]].
- **cor-15 — Export CSV** : Export de données tabulaires au format CSV. Le format XML est explicitement écarté ([[wiki/decision-no-xml]]).

## Prochain

- **cor-18 — Tableau de bord analytique** : Vue agrégée des métriques d'usage. [priorité relative non documentée dans le wiki — position dans le backlog à confirmer avec le propriétaire.]

## Bloqué

- **cor-22 — SSO entreprise** : Intégration SAML 2.0. Bloqué par cor-11. [Le wiki ne documente pas ce blocage — consulter directement l'état du bead cor-11 pour le détail.]

## Décisions structurantes

- [[wiki/decision-focus-smb]] — Le produit cible les PME en 2026 ; grands comptes et enterprise sont hors périmètre.
- [[wiki/decision-no-xml]] — XML et XLSX sont écartés de la v1 ; CSV est le seul format d'export supporté.

## Sources

Pages wiki consultées :
- [[wiki/decision-focus-smb]]
- [[wiki/decision-no-xml]]
- [[wiki/feature-onboarding]]

Pages absentes (lacunes signalées) :
- segment-* : aucune page lue (non pertinent pour ce périmètre, ou absent du wiki)
```

---

## Points illustrés par cet exemple

1. **Citation systématique** : chaque affirmation de priorité ou de périmètre cite la page wiki source avec `[[wiki/slug]]`. Rien n'est affirmé sans trace.
2. **Lacune explicite sur la priorité** : cor-18 n'a pas de priorité documentée dans le wiki — la skill le dit clairement plutôt que de supposer un rang.
3. **Lacune sur le blocage** : le blocage de cor-22 est connu via beads (`blocked_by: cor-11`) mais non documenté dans le wiki — la skill cite le bead et signale l'absence de documentation wiki.
4. **Anti-lissage** : la section Vision cite uniquement ce que les décisions wiki documentent ; elle ne produit pas de discours stratégique générique sur « la valeur client » ou « l'alignement produit ».
5. **Décision respectée** : cor-15 (Export CSV) est bien en cours, et la contrainte XML est rappelée depuis `decision-no-xml`, pas inventée.
6. **Slug correct** : `Q2 orienté clients` → `q2-oriente-clients` (kebab-case ASCII, minuscules, sans accents).
7. **Scope partiel** : le périmètre « Q2 orienté clients » a conduit la skill à lire `feature-onboarding` (pertinent) mais à ignorer d'éventuelles pages `segment-*` sans lien évident — comportement documenté dans les Sources.

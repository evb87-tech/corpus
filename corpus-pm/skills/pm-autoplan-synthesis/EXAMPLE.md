# Exemple — /pm-autoplan

> Cet exemple illustre le comportement attendu de la skill `corpus-pm:pm-autoplan-synthesis` sur deux cas synthétiques et un cas limite.

---

## Cas 1 — Conflits inter-angles détectés

### Vault de départ (seeded)

Les trois pages de stress-test ont été produites par `/pm-review-strategy`, `/pm-review-user` et `/pm-review-feasibility` sur le brouillon `output/2026-04-28-feature-notifications-prd.md`.

```
wiki/
  index.md
  log.md
  stress-test-feature-notifications-prd-strategy-2026-04-28.md
  stress-test-feature-notifications-prd-user-2026-04-28.md
  stress-test-feature-notifications-prd-feasibility-2026-04-28.md
  decision-no-sync-api.md
  decision-postgres-only.md
  persona-sarah-chef-de-projet.md
  persona-marc-developpeur.md
  feature-notifications.md
output/
  2026-04-28-feature-notifications-prd.md
```

Extraits des trois stress-tests :

**`wiki/stress-test-feature-notifications-prd-strategy-2026-04-28.md`** (extrait) :
> L'exigence WebSocket (P0) contredit [[wiki/decision-no-sync-api]] (séquencement hors périmètre v1). Pas d'impact sur le positionnement long terme — le problème des mises à jour manquées est documenté dans [[wiki/feature-notifications]]. Coût d'opportunité : l'effort WebSocket retarde la fonctionnalité de recherche documentée dans le backlog.

**`wiki/stress-test-feature-notifications-prd-user-2026-04-28.md`** (extrait) :
> [[wiki/persona-sarah-chef-de-projet]] est desservie par le PRD : ses frictions (mises à jour manquées) sont adressées. [[wiki/persona-marc-developpeur]] est ignoré : son besoin de faible latence (< 100 ms) est documenté dans son champ `## Frictions` — le polling 30 s du brouillon ne répond pas à ce critère. Verbatim de Marc : « J'ai besoin de voir les changements sans recharger » (source : [[wiki/persona-marc-developpeur]]).

**`wiki/stress-test-feature-notifications-prd-feasibility-2026-04-28.md`** (extrait) :
> WebSocket contredit [[wiki/decision-no-sync-api]]. Redis contredit [[wiki/decision-postgres-only]]. La dépendance polling 30 s (alternative technique retenue par la décision) est faisable mais non documentée dans le PRD comme choix délibéré.

### Commande lancée

```
/pm-autoplan output/2026-04-28-feature-notifications-prd.md
```

### Comportement attendu

**Phase d'orchestration :** la commande lance `/pm-review-strategy`, `/pm-review-user` et `/pm-review-feasibility` en parallèle. Les trois pages de stress-test sont produites et vérifiées.

**Phase de synthèse :** la skill `corpus-pm:pm-autoplan-synthesis` lit les trois pages et détecte deux conflits inter-angles.

**Conflits inter-angles identifiés :**

1. **Conflit sur la solution technique (WebSocket vs polling)**
   - L'angle stratégie dit : le coût WebSocket retarde le backlog — signal de priorisation.
   - L'angle utilisateur dit : Marc (persona documenté) a besoin de faible latence — le polling 30 s ne le sert pas.
   - L'angle faisabilité dit : WebSocket contredit [[wiki/decision-no-sync-api]] — hard stop technique.
   - Les trois angles couvrent le même point mais depuis des registres différents. La skill ne tranche pas.

2. **Conflit sur le périmètre du persona servi**
   - L'angle utilisateur dit : Sarah est servie, Marc ne l'est pas.
   - L'angle stratégie ne mentionne pas Marc — lacune de couverture.

### Synthèse produite

Fichier : `output/2026-04-28-autoplan-feature-notifications-prd.md`

```markdown
---
type: autoplan-synthesis
draft: output/2026-04-28-feature-notifications-prd.md
date: 2026-04-28
stress-tests:
  strategy: wiki/stress-test-feature-notifications-prd-strategy-2026-04-28.md
  user: wiki/stress-test-feature-notifications-prd-user-2026-04-28.md
  feasibility: wiki/stress-test-feature-notifications-prd-feasibility-2026-04-28.md
wiki-sources: [raw/architecture-review-2026-01.md, raw/infra-costs-2025.md, raw/user-interviews-2026-03.md]
---

# Synthèse autoplan — PRD Notifications temps-réel

> Note : ce document est une moyenne statistique des trois angles de revue, non la position du propriétaire.
> Il présente les preuves recueillies par chaque angle. Le propriétaire arbitre quelles critiques traiter.
> Produit par /pm-autoplan le 2026-04-28.

## Angle stratégie

*Source : [[wiki/stress-test-feature-notifications-prd-strategy-2026-04-28]]*

L'exigence WebSocket (P0) contredit [[wiki/decision-no-sync-api]] — décision datée du 2026-01-20 qui écarte explicitement la synchronisation temps-réel pour la v1. L'angle stratégie signale un coût d'opportunité : l'effort WebSocket retarde la fonctionnalité de recherche documentée dans le backlog. Le problème des mises à jour manquées est bien ancré dans [[wiki/feature-notifications]].

## Angle utilisateur

*Source : [[wiki/stress-test-feature-notifications-prd-user-2026-04-28]]*

[[wiki/persona-sarah-chef-de-projet]] est desservie : ses frictions (mises à jour manquées) sont adressées par le PRD. [[wiki/persona-marc-developpeur]] est non servi : son critère de faible latence (< 100 ms, champ `## Frictions`) n'est pas couvert par le polling 30 s retenu. Verbatim de Marc (source : [[wiki/persona-marc-developpeur]]) : « J'ai besoin de voir les changements sans recharger. »

## Angle faisabilité

*Source : [[wiki/stress-test-feature-notifications-prd-feasibility-2026-04-28]]*

Deux claims P0 contredits par des décisions wiki :

> **[[wiki/decision-no-sync-api]]** (2026-01-20) : « Non. La synchronisation temps-réel est hors périmètre pour la v1. Le polling HTTP toutes les 30 secondes est retenu comme solution transitoire. »
> L'exigence WebSocket P0 contredit cette décision.

> **[[wiki/decision-postgres-only]]** (2026-01-20) : « Non. PostgreSQL est la seule base de données retenue pour la v1. Redis introduit une dépendance d'infrastructure supplémentaire non justifiée au volume actuel. »
> L'exigence Redis P0 contredit cette décision.

La persistance PostgreSQL (P1) est ancrée et cohérente.

## Conflits inter-angles

**Conflit 1 — Solution technique (WebSocket vs polling)**

- **Angle stratégie** ([[wiki/stress-test-feature-notifications-prd-strategy-2026-04-28]], source : [[wiki/decision-no-sync-api]]) : l'effort WebSocket retarde le backlog — signal de priorisation à arbitrer.
- **Angle utilisateur** ([[wiki/stress-test-feature-notifications-prd-user-2026-04-28]], source : [[wiki/persona-marc-developpeur]]) : le polling 30 s ne répond pas au besoin de faible latence de Marc.
- **Angle faisabilité** ([[wiki/stress-test-feature-notifications-prd-feasibility-2026-04-28]], source : [[wiki/decision-no-sync-api]]) : WebSocket est explicitement hors périmètre v1 selon la décision d'architecture.

**Conflit 2 — Couverture persona**

- **Angle utilisateur** ([[wiki/stress-test-feature-notifications-prd-user-2026-04-28]], source : [[wiki/persona-marc-developpeur]]) : Marc (persona documenté) n'est pas servi par le brouillon actuel.
- **Angle stratégie** ([[wiki/stress-test-feature-notifications-prd-strategy-2026-04-28]]) : Marc n'est pas mentionné — lacune de couverture dans la revue stratégique.

## Questions ouvertes agrégées

- [Angle faisabilité] La décision [[wiki/decision-no-sync-api]] a-t-elle été formellement reouverte ? Si oui, déposer le document de réévaluation dans `raw/` et relancer `/ingest`.
- [Angle faisabilité] La décision [[wiki/decision-postgres-only]] a-t-elle été reouverte ? Même démarche.
- [Angle utilisateur] Le critère de latence de Marc (< 100 ms) est-il négociable ? Aucune source wiki ne documente ce point. [lacune]
- [Angle stratégie] La fonctionnalité de recherche est citée comme concurrente en coût d'opportunité — mais aucune page wiki ne documente sa priorité relative. [lacune]

## Sources consultées

Pages de stress-test :
- [[wiki/stress-test-feature-notifications-prd-strategy-2026-04-28]]
- [[wiki/stress-test-feature-notifications-prd-user-2026-04-28]]
- [[wiki/stress-test-feature-notifications-prd-feasibility-2026-04-28]]

Pages wiki sous-jacentes (union des trois revues) :
- [[wiki/decision-no-sync-api]]
- [[wiki/decision-postgres-only]]
- [[wiki/feature-notifications]]
- [[wiki/persona-sarah-chef-de-projet]]
- [[wiki/persona-marc-developpeur]]
```

**Récapitulatif affiché par la skill :**

```
=== Synthèse autoplan terminée ===
Brouillon analysé   : /vault/output/2026-04-28-feature-notifications-prd.md
Synthèse produite   : /vault/output/2026-04-28-autoplan-feature-notifications-prd.md
Stress-tests lus    : stratégie, utilisateur, faisabilité
Conflits inter-angles : 2 (listés dans ## Conflits inter-angles)
Lacunes agrégées    : 4
```

### Points illustrés

1. **Double traçabilité** — chaque claim cite à la fois le stress-test source (`[[wiki/stress-test-...]]`) et la page wiki sous-jacente (`[[wiki/...]]`).
2. **Conflits inter-angles sans harmonisation** — les trois angles couvrent le même point WebSocket depuis des registres différents ; aucun n'est écarté ni moyenné.
3. **Absence de recommandation** — la synthèse ne dit pas quoi faire. Elle dit ce que chaque angle a trouvé.
4. **Persona non servi surfacé** — la lacune de couverture de Marc par l'angle stratégie est signalée dans Conflits inter-angles, pas effacée.

---

## Cas 2 — Aucun conflit inter-angles

### Situation

Les trois stress-tests convergent : le brouillon de polling est cohérent avec les décisions wiki, Sarah est servie, Marc est explicitement mentionné dans « Hors périmètre », et aucune décision n'est contredite.

### Comportement attendu de la skill

La section `## Conflits inter-angles` conclut :

```
Aucun conflit inter-angles détecté sur les points couverts par les trois revues.
```

La synthèse note quand même les questions ouvertes communes (ex. : lacune sur les métriques de latence) et liste les pages wiki consultées pour auditabilité.

### Points illustrés

1. **Déclaration explicite "aucun conflit"** — la skill ne fabrique pas de tensions pour paraître utile.
2. **Traçabilité même sans conflit** — les stress-tests et leurs sources wiki sont listés dans `## Sources consultées`.

---

## Cas limite — revue partielle (arrêt dur)

Si l'une des trois pages de stress-test est absente au moment de l'appel à la skill, la commande `/pm-autoplan` a déjà refusé avant de déléguer. La skill n'est pas invoquée.

Mais si la skill est appelée directement avec une page manquante, elle refuse :

```
ARRÊT : La page de stress-test suivante est introuvable :
  /vault/wiki/stress-test-feature-notifications-prd-user-2026-04-28.md
La synthèse ne peut pas être produite avec des revues partielles.
Relancez /pm-review-user <brouillon> pour produire la page manquante, puis relancez /pm-autoplan.
Aucun fichier de synthèse créé.
```

Aucune écriture dans le vault.

---

## Cas limite — stress-test sans sources wiki (violation de provenance)

Si l'un des stress-tests a `sources: []` dans son frontmatter (violation de provenance héritée), la skill signale la violation dans `## Questions ouvertes agrégées` :

```
VIOLATION DE PROVENANCE : [[wiki/stress-test-<slug>-strategy-<date>]] ne cite aucune source wiki sous-jacente — provenance cassée. Les claims issus de cet angle sont non traçables vers des sources raw/. Relancer /pm-review-strategy pour régénérer la page avec provenance correcte.
```

La synthèse est quand même produite. Le champ `wiki-sources:` omet les sources de la page défaillante.

# Exemple — /pm-review-feasibility

> Cet exemple illustre le comportement attendu de la skill `corpus-pm:review-feasibility` sur deux cas synthétiques et un cas limite.

---

## Cas 1 — Brouillon contredisant une décision d'architecture

### Vault de départ (seeded)

```
wiki/
  index.md
  log.md
  decision-no-sync-api.md      — type: decision, décision: pas d'API de sync temps-réel en v1
  decision-postgres-only.md    — type: decision, décision: PostgreSQL uniquement, pas de Redis
  feature-notifications.md     — type: feature, problème: utilisateurs manquent les mises à jour
output/
  2026-04-28-feature-notifications-prd.md
```

Contenu de `wiki/decision-no-sync-api.md` (extrait pertinent) :

```markdown
---
type: decision
sources: [raw/architecture-review-2026-01.md]
last_updated: 2026-01-20
decision-date: 2026-01-20
---

# Pas d'API de sync temps-réel en v1

## Date

2026-01-20

## Question

Faut-il implémenter une API WebSocket pour les mises à jour temps-réel en v1 ?

## Décision

Non. La synchronisation temps-réel est hors périmètre pour la v1. Le polling HTTP toutes les 30 secondes est retenu comme solution transitoire. Coût de maintenance des connexions WebSocket jugé disproportionné au stade actuel.

## Alternatives écartées

- WebSocket : complexité opérationnelle trop élevée pour la v1.
- Server-Sent Events : différé à v2 selon la charge utilisateur observée.

## Personnes impliquées

Équipe architecture, CTO.

## Sources

- [[raw/architecture-review-2026-01.md]]
```

Contenu de `wiki/decision-postgres-only.md` (extrait pertinent) :

```markdown
---
type: decision
sources: [raw/architecture-review-2026-01.md, raw/infra-costs-2025.md]
last_updated: 2026-01-20
decision-date: 2026-01-20
---

# PostgreSQL uniquement — pas de Redis en v1

## Date

2026-01-20

## Question

Faut-il ajouter Redis pour la gestion des sessions et du cache en v1 ?

## Décision

Non. PostgreSQL est la seule base de données retenue pour la v1. Redis introduit une dépendance d'infrastructure supplémentaire non justifiée au volume actuel. Réévaluation prévue à 10 000 utilisateurs actifs.

## Alternatives écartées

- Redis : surcoût infrastructure sans bénéfice mesurable sous 10 000 utilisateurs.
- Memcached : écarté pour les mêmes raisons.

## Personnes impliquées

Équipe infra, CTO.

## Sources

- [[raw/architecture-review-2026-01.md]]
- [[raw/infra-costs-2025.md]]
```

Contenu du brouillon `output/2026-04-28-feature-notifications-prd.md` (extrait) :

```markdown
---
type: prd
feature: notifications temps-réel
date: 2026-04-28
status: draft
---

# PRD — Notifications temps-réel

## Problème

Les utilisateurs ratent des mises à jour critiques car le rechargement manuel est trop lent.

## Exigences

- [P0] Les notifications arrivent en temps réel via WebSocket (< 500 ms de délai).
- [P0] Un cache Redis stocke les 50 dernières notifications par utilisateur pour accès rapide.
- [P1] Les notifications non lues persistent en base de données.

## Dépendances techniques

- Infrastructure WebSocket gérée par le backend Node.js.
- Redis 7.x pour le cache de notifications.
- PostgreSQL pour la persistance des notifications lues/non lues.

## Métriques de succès

- 95 % des notifications délivrées en moins de 500 ms.
- Taux d'ouverture des notifications > 60 %.
```

### Commande lancée

```
/pm-review-feasibility output/2026-04-28-feature-notifications-prd.md
```

### Comportement attendu de la skill

**Étape 1 — Lecture du wiki :** la skill lit `wiki/index.md`, puis `wiki/decision-no-sync-api.md`, `wiki/decision-postgres-only.md`, et `wiki/feature-notifications.md`.

**Étape 2 — Claims techniques identifiés :**
1. Notifications via WebSocket (< 500 ms)
2. Cache Redis pour les 50 dernières notifications
3. PostgreSQL pour la persistance
4. Infrastructure WebSocket gérée par Node.js

**Étape 3 — Analyse :** deux contradictions directes détectées avec les décisions wiki.

**Page de stress-test produite :**

Fichier : `wiki/stress-test-feature-notifications-prd-feasibility-2026-04-28.md`

```markdown
---
type: stress-test
sources: [raw/architecture-review-2026-01.md, raw/infra-costs-2025.md]
last_updated: 2026-04-28
draft: output/2026-04-28-feature-notifications-prd.md
review-angle: feasibility
---

# Stress-test faisabilité — PRD Notifications temps-réel

## Résumé

Le brouillon contredit deux décisions d'architecture documentées. L'exigence WebSocket (P0) est explicitement hors périmètre v1 selon [[wiki/decision-no-sync-api]]. L'exigence Redis (P0) est également écartée par [[wiki/decision-postgres-only]] jusqu'à 10 000 utilisateurs actifs. Ces deux points doivent être soumis à l'équipe technique avant validation du périmètre. La persistance PostgreSQL (P1) est cohérente avec le wiki.

## Ce que disent les sources

**[[wiki/decision-no-sync-api]]** : la décision du 2026-01-20 écarte explicitement les WebSockets et les Server-Sent Events pour la v1. Le polling HTTP toutes les 30 secondes est la solution transitoire retenue. La décision cite la complexité opérationnelle comme motif principal.

**[[wiki/decision-postgres-only]]** : PostgreSQL est la seule base de données autorisée en v1. Redis est explicitement écarté jusqu'au seuil de 10 000 utilisateurs actifs. La décision cite le surcoût infrastructure sans bénéfice mesurable à volume actuel.

**[[wiki/feature-notifications]]** : le problème des mises à jour manquées est bien documenté. La page ne documente pas de contrainte de délai — le critère « < 500 ms » du brouillon n'est pas ancré dans le wiki.

## Connexions

- [[wiki/decision-no-sync-api]] : décision directement contredite par l'exigence P0 WebSocket
- [[wiki/decision-postgres-only]] : décision directement contredite par l'exigence P0 Redis
- [[wiki/feature-notifications]] : feature connexe — problème aligné, solution non validée

## Contradictions

**Contradiction 1 — WebSocket (P0) vs [[wiki/decision-no-sync-api]] :**
Le brouillon pose comme exigence P0 : « Les notifications arrivent en temps réel via WebSocket (< 500 ms de délai). »
La décision wiki tranche : « Non. La synchronisation temps-réel est hors périmètre pour la v1. Le polling HTTP toutes les 30 secondes est retenu comme solution transitoire. »
Cette contradiction est directe. L'exigence P0 réintroduit une technologie que la décision a explicitement écartée.

**Contradiction 2 — Redis (P0) vs [[wiki/decision-postgres-only]] :**
Le brouillon pose comme exigence P0 : « Un cache Redis stocke les 50 dernières notifications par utilisateur pour accès rapide. »
La décision wiki tranche : « Non. PostgreSQL est la seule base de données retenue pour la v1. Redis introduit une dépendance d'infrastructure supplémentaire non justifiée au volume actuel. »
L'exigence P0 Redis contredit directement cette décision sans mention d'une réévaluation formelle.

## Questions ouvertes

- Les décisions [[wiki/decision-no-sync-api]] et [[wiki/decision-postgres-only]] ont-elles été formellement rouvertes ? Si oui, déposer le document de réévaluation dans `raw/` et relancer `/ingest`.
- La métrique « < 500 ms » n'est documentée dans aucune page wiki. [lacune — origine du critère non traçable vers une source wiki]
- Le taux d'ouverture cible (> 60 %) ne trouve aucune référence dans le wiki. [lacune — aucune donnée de référence sur ce type de métrique]

## Faisabilité des claims techniques

| Claim technique | Niveau | Sources wiki | Note |
|---|---|---|---|
| Notifications via WebSocket < 500 ms | contredit | [[wiki/decision-no-sync-api]] | WebSocket explicitement écarté pour la v1 |
| Cache Redis (50 notifications) | contredit | [[wiki/decision-postgres-only]] | Redis explicitement écarté pour la v1 |
| Persistance PostgreSQL | ancré | [[wiki/decision-postgres-only]] | PostgreSQL seule BDD autorisée v1 — cohérent |
| Infrastructure WebSocket Node.js | non documenté | — | [lacune] Aucune page wiki ne documente la capacité WebSocket du backend |

## Dépendances

**Redis 7.x** — [lacune] Déclarée comme dépendance P0 dans le brouillon. La page [[wiki/decision-postgres-only]] écarte explicitement Redis. La dépendance est non validée par le wiki.

**WebSocket (backend Node.js)** — [lacune] Pas de page wiki documentant la capacité WebSocket du service backend. La dépendance est non documentée ET contredite par [[wiki/decision-no-sync-api]].

**PostgreSQL** — Documenté et validé par [[wiki/decision-postgres-only]]. Dépendance cohérente pour la persistance des notifications.

## Risques d'intégration

Depuis [[wiki/decision-no-sync-api]] : la gestion des connexions WebSocket persistantes a été identifiée comme complexité opérationnelle disproportionnée au stade v1. Ouvrir des connexions WebSocket par utilisateur actif introduit des risques de stabilité documentés dans la décision.

Depuis [[wiki/decision-postgres-only]] : ajouter Redis introduit une deuxième couche d'infrastructure à opérer. Le wiki documente ce risque comme motif explicite de l'écarter.

Le wiki ne documente pas d'autres risques d'intégration spécifiques aux notifications. Toute évaluation supplémentaire relève de l'appréciation technique.

## Décisions contredites

> **[[wiki/decision-no-sync-api]]** (décision datée du 2026-01-20) : « Non. La synchronisation temps-réel est hors périmètre pour la v1. Le polling HTTP toutes les 30 secondes est retenu comme solution transitoire. Coût de maintenance des connexions WebSocket jugé disproportionné au stade actuel. »
> Le brouillon contredit cette décision en : posant l'infrastructure WebSocket comme exigence P0 sans mention d'une révision formelle de la décision.

> **[[wiki/decision-postgres-only]]** (décision datée du 2026-01-20) : « Non. PostgreSQL est la seule base de données retenue pour la v1. Redis introduit une dépendance d'infrastructure supplémentaire non justifiée au volume actuel. Réévaluation prévue à 10 000 utilisateurs actifs. »
> Le brouillon contredit cette décision en : incluant Redis comme dépendance P0 sans documenter que le seuil de 10 000 utilisateurs est atteint ni qu'une réévaluation formelle a eu lieu.

---

Sources consultées : [[wiki/decision-no-sync-api]], [[wiki/decision-postgres-only]], [[wiki/feature-notifications]]
```

**Récapitulatif affiché par la skill :**

```
=== Stress-test faisabilité terminé ===
Brouillon analysé   : /vault/output/2026-04-28-feature-notifications-prd.md
Page produite       : /vault/wiki/stress-test-feature-notifications-prd-feasibility-2026-04-28.md
Pages wiki lues     : wiki/decision-no-sync-api.md, wiki/decision-postgres-only.md, wiki/feature-notifications.md
Claims techniques   : 4
Claims ancrés       : 1
Claims non documentés (lacunes): 1
Décisions contredites: 2
```

---

## Cas 2 — Brouillon cohérent avec toutes les décisions wiki

### Vault de départ (seeded)

```
wiki/
  index.md
  log.md
  decision-no-sync-api.md      — même contenu que ci-dessus
  decision-postgres-only.md    — même contenu que ci-dessus
  feature-notifications.md     — type: feature, problème: utilisateurs manquent les mises à jour
output/
  2026-04-28-feature-notifications-polling-prd.md
```

Contenu du brouillon `output/2026-04-28-feature-notifications-polling-prd.md` (extrait) :

```markdown
---
type: prd
feature: notifications par polling
date: 2026-04-28
status: draft
---

# PRD — Notifications par polling

## Problème

Les utilisateurs ratent des mises à jour critiques.

## Exigences

- [P0] Le client interroge le serveur toutes les 30 secondes pour les nouvelles notifications.
- [P0] Les notifications sont stockées en PostgreSQL avec statut lu/non lu.
- [P1] Une pastille de compteur s'affiche sur l'icône de cloche si des notifications sont non lues.

## Hors périmètre

- Notifications WebSocket : hors périmètre v1 (voir decision-no-sync-api).
- Cache Redis : hors périmètre v1 (voir decision-postgres-only).
```

### Comportement attendu de la skill

**Analyse :** le brouillon est cohérent avec les deux décisions wiki. Il exclut explicitement WebSocket et Redis dans sa section « Hors périmètre ».

**Page produite :** `wiki/stress-test-feature-notifications-polling-prd-feasibility-2026-04-28.md`

La section `## Décisions contredites` conclut :

```
Aucune décision wiki contredite. Pages consultées : [[wiki/decision-no-sync-api]], [[wiki/decision-postgres-only]], [[wiki/feature-notifications]].
```

Le Résumé note : « Aucune préoccupation de faisabilité majeure. Le brouillon est cohérent avec les décisions d'architecture documentées. »

### Points illustrés

1. **Déclaration explicite "aucune préoccupation majeure"** — la skill ne fabrique pas de critiques pour paraître utile.
2. **Traçabilité même sans contradiction** — les décisions consultées sont listées dans `## Décisions contredites` pour auditabilité.
3. **Section hors périmètre appréciée positivement** — aligner le brouillon explicitement sur les décisions wiki est reconnu comme bonne pratique.

---

## Cas limite — wiki sans page decision-* (arrêt dur)

Si le vault ne contient aucune page `wiki/decision-*`, la skill refuse immédiatement :

```
ARRÊT : Le wiki ne contient aucune page decision-*.
Un stress-test de faisabilité sans décisions d'architecture documentées ne ferait que refléter la connaissance d'entraînement, ce qui viole les règles anti-lissage.
Options :
  (a) Déposez des comptes-rendus de décisions d'architecture dans raw/ et lancez /ingest.
  (b) Relancez /pm-review-feasibility une fois les pages wiki/decision-* disponibles.
Aucune page de stress-test créée.
```

Aucune page de stress-test n'est produite. Aucune écriture dans le vault.

---

## Cas limite — page wiki avec sources vides (violation de provenance)

Si une page `wiki/decision-nom.md` consultée a `sources: []`, la skill continue la génération mais signale la violation dans `## Questions ouvertes` :

```
VIOLATION DE PROVENANCE : [[wiki/decision-nom]] a été consultée mais ne cite aucune source raw/. Les claims issus de cette page sont non traçables. Vérifier et corriger la page wiki ou relancer /ingest depuis la source originale.
```

La page de stress-test est produite. Le champ `sources:` du stress-test omet la page défaillante (pas de raw/ à propager).

# Evals — commandes corpus-pm

Ce répertoire contient les scénarios d'évaluation pour les commandes corpus-pm :
`/pm-review-strategy`, `/pm-review-user` et `/pm-epic`.

---

## Structure

```
evals/commands/
├── README.md                                   ← ce fichier
├── pm-review-strategy-01-happy.md              ← /pm-review-strategy happy path
├── pm-review-strategy-02-edge-no-metrics.md    ← /pm-review-strategy sans métriques
├── pm-review-strategy-03-trap-empty-wiki.md    ← /pm-review-strategy piège §2 §3
├── pm-review-user-01-happy.md                  ← /pm-review-user happy path
├── pm-review-user-02-edge-unknown-persona.md   ← /pm-review-user persona inconnu
├── pm-review-user-03-trap-no-personas.md       ← /pm-review-user piège §2 §3
├── pm-epic-01-happy.md                         ← /pm-epic happy path
├── pm-epic-02-edge-vague-metrics.md            ← /pm-epic métriques vagues
└── pm-epic-03-trap-no-metrics.md               ← /pm-epic piège §2 (section absente)
```

Les fixtures (PRD de test) sont dans `evals/fixtures/`.

---

## Format des evals

Même format que `corpus-core/evals/commands/README.md`. Frontmatter :

```yaml
---
eval: <identifiant>
command: /nom-de-la-commande
type: happy-path | edge-case | anti-lissage-trap
audience: native-fr
suppresses: anti-lissage §N | —
---
```

Sections : `## Scénario`, `## Setup`, `## Prompt`, `## Pass criteria`, `## Fail signals`.

---

## Taxonomie des scénarios

### `/pm-review-strategy`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `pm-review-strategy-01-happy.md` | PRD avec contexte wiki complet → stress-test stratégie déposé dans `wiki/`, décision contredite citée verbatim | §général |
| `pm-review-strategy-02-edge-no-metrics.md` | PRD sans métriques → pm-strategist continue (pas de refus), lacune signalée | §général |
| `pm-review-strategy-03-trap-empty-wiki.md` | Wiki sans `decision-*` ni `feature-*` → arrêt dur, pas de stress-test inventé | §2 §3 |

**Note :** L'absence de section `## Métriques de succès` dans le PRD n'est pas un motif
de refus pour le pm-strategist (c'est le pm-decomposer qui refuse pour ce motif). Le
pm-strategist s'arrête uniquement quand le wiki ne contient aucune page `decision-*` ni
`feature-*`.

### `/pm-review-user`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `pm-review-user-01-happy.md` | PRD avec personas et interviews wiki → personas servis/non servis, verbatims EN préservés | §4 §général |
| `pm-review-user-02-edge-unknown-persona.md` | PRD cible persona absent du wiki → lacune signalée, pas de profil inventé | §2 §3 |
| `pm-review-user-03-trap-no-personas.md` | Wiki sans `persona-*` ni `interview-*` → arrêt total, pas d'analyse inventée | §2 §3 |

**Note :** L'arrêt total du pm-user-advocate se déclenche seulement si le wiki n'a
**aucune** page `persona-*` ni `interview-*`. Si au moins une page persona existe, la
commande continue même si certains personas du PRD sont inconnus.

### `/pm-epic`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `pm-epic-01-happy.md` | PRD complet → epic avec `## Success Criteria`, issues P0/P1 avec critères d'acceptation, liées à l'epic | §général |
| `pm-epic-02-edge-vague-metrics.md` | PRD avec métriques vagues → epic créé, métriques verbatim non réécrites, faiblesse signalée | §2 |
| `pm-epic-03-trap-no-metrics.md` | PRD sans section `## Métriques de succès` → refus immédiat, aucune issue créée | §2 |

**Note :** Le pm-decomposer refuse uniquement si la section `## Métriques de succès` est
**absente**. Des métriques vagues (présentes mais non mesurables) ne déclenchent pas le
refus — elles doivent être reprises verbatim et la faiblesse doit être signalée.

---

## Commandes non couvertes dans cet eval

`/pm-spec` est disponible dans `corpus-pm/commands/pm-spec.md` mais n'a pas encore
d'evals dédiés. Les scénarios à prévoir pour une version future :

- Happy path : description feature → PRD complet avec toutes les sections canoniques.
- Edge case : description vague → demande de clarification avant rédaction.
- Trap : PRD généré sans base wiki → modèle doit signaler l'absence de personas ou de
  décisions dans le wiki plutôt que de générer un PRD générique.

Déféré pour un bead ultérieur.

---

## Comment exécuter un eval

Suivre la procédure générale décrite dans `corpus-core/evals/README.md`.

En résumé :
1. Ouvrir une session Claude Code fraîche avec `CORPUS_VAULT` pointant vers un vault de test.
2. Initialiser le vault : `/init-vault $CORPUS_VAULT` si nécessaire.
3. Mettre en place le `## Setup` (copier les fixtures depuis `evals/fixtures/`).
4. Taper le `## Prompt` exact.
5. Vérifier les `## Pass criteria` un par un.
6. Consigner le résultat (pass/fail + motif) dans le PR.

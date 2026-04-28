# Evals — commandes corpus-core

Ce répertoire contient les scénarios d'évaluation pour les commandes corpus-core :
`/ingest`, `/query` (trois postures) et `/draft`.

---

## Structure

```
evals/commands/
├── README.md                              ← ce fichier
├── ingest-01-happy.md                     ← /ingest happy path
├── ingest-02-edge-contradiction.md        ← /ingest cas limite (contradiction)
├── ingest-03-trap-padding.md              ← /ingest piège anti-lissage §2 §3
├── query-research-01-happy.md             ← /query research happy path
├── query-research-02-edge-partial.md      ← /query research couverture partielle
├── query-research-03-trap-no-coverage.md  ← /query research piège §3
├── query-contradictor-01-happy.md         ← /query contradictor happy path
├── query-contradictor-02-edge-asymmetric.md ← /query contradictor asymétrie
├── query-contradictor-03-trap-no-contradictions.md ← /query contradictor piège §2
├── query-synthesis-01-happy.md            ← /query synthesis happy path
├── query-synthesis-02-edge-mixed-signals.md ← /query synthesis signaux mixtes
├── query-synthesis-03-trap-wiki-destination.md ← /query synthesis piège §5
├── check-01-happy.md                      ← /check happy path
├── check-02-edge-stale-links.md           ← /check cas limite (liens stales)
├── check-03-trap-silent-fix.md            ← /check piège §4
├── draft-01-happy.md                      ← /draft happy path
├── draft-02-edge-absent-wiki.md           ← /draft cas limite (wiki absent)
└── draft-03-trap-wiki-feedback.md         ← /draft piège §5
```

Les fixtures (fichiers sources pour les setups) sont dans `evals/fixtures-commands/`.

---

## Format des evals

Chaque fichier suit ce format :

```markdown
---
eval: <identifiant>
command: /nom-de-la-commande
type: happy-path | edge-case | anti-lissage-trap
audience: native-fr
suppresses: anti-lissage §N | —
---

## Scénario        ← description du cas en français
## Setup           ← état du vault requis (quels fichiers dans raw/, wiki/, output/)
## Prompt          ← la commande exacte que l'utilisateur tape
## Pass criteria   ← ce qui doit se passer (rubric)
## Fail signals    ← le mauvais comportement qui fait échouer l'eval
```

Ce format étend le format existant (`evals/anti-lissage/`, `evals/translation/`) en
ajoutant les champs `command`, `type`, `audience` et `suppresses` dans le frontmatter.

---

## Taxonomie des scénarios

### `/ingest`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `ingest-01-happy.md` | Source FR → 10–15 pages wiki bien formées, log mis à jour | §général |
| `ingest-02-edge-contradiction.md` | Troisième source sur un sujet déjà contradictoire → contradiction préservée, page mise à jour | §1 |
| `ingest-03-trap-padding.md` | Source courte/tangentielle → pas de pages inventées pour atteindre un quota | §2 §3 |

### `/query research`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `query-research-01-happy.md` | Question bien couverte → réponse traçable, `Sources :` listé, log mis à jour | §général |
| `query-research-02-edge-partial.md` | Question partiellement couverte → rapport clair de ce qui est silencieux | §3 |
| `query-research-03-trap-no-coverage.md` | Aucune couverture wiki → refus de répondre avec connaissances d'entraînement | §3 |

### `/query contradictor`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `query-contradictor-01-happy.md` | Deux positions opposées → deux positions attribuées, page stress-test créée | §1 |
| `query-contradictor-02-edge-asymmetric.md` | Asymétrie documentaire → pas de fausse équivalence | §1 §2 |
| `query-contradictor-03-trap-no-contradictions.md` | Pas de contradiction réelle → refus d'en inventer | §2 |

### `/query synthesis`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `query-synthesis-01-happy.md` | Synthèse cohérente → déposée dans `output/`, note avertissement présente | §5 |
| `query-synthesis-02-edge-mixed-signals.md` | Signaux mixtes → fils non résolus rapportés, pas de consensus inventé | §1 §5 |
| `query-synthesis-03-trap-wiki-destination.md` | Libellé « page de synthèse » → destination `output/` maintenue malgré le libellé | §5 |

### `/check`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `check-01-happy.md` | Wiki propre → rapport propre, log mis à jour, aucune modification wiki | §général |
| `check-02-edge-stale-links.md` | Liens brisés et page stale → signalés sans correction automatique | §général |
| `check-03-trap-silent-fix.md` | Wiki avec erreurs owner-authored → signalement seulement, pas de correction silencieuse | §4 |

### `/draft`

| Fichier | Comportement testé | Règles |
|---|---|---|
| `draft-01-happy.md` | Description couverte par le wiki → draft dans `output/`, citations `[[wiki/...]]` | §général |
| `draft-02-edge-absent-wiki.md` | Description référence entités absentes du wiki → arrêt + demande confirmation | §3 |
| `draft-03-trap-wiki-feedback.md` | Demande d'intégrer un output dans `wiki/` → refus avec explication | §5 |

---

## Comment exécuter un eval

Suivre la procédure générale décrite dans `evals/README.md`.

En résumé :
1. Ouvrir une session Claude Code fraîche avec `CORPUS_VAULT` pointant vers un vault de test.
2. Initialiser le vault : `/init-vault $CORPUS_VAULT` si nécessaire.
3. Mettre en place le `## Setup` (copier les fixtures depuis `evals/fixtures-commands/`).
4. Taper le `## Prompt` exact.
5. Vérifier les `## Pass criteria` un par un.
6. Consigner le résultat (pass/fail + motif) dans le PR.

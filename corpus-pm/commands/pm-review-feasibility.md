---
description: Stress-teste un brouillon (PRD, roadmap ou autre output/) sous l'angle faisabilité technique — claims de complexité, dépendances, risques d'intégration et décisions d'architecture antérieures. Triggers — est-ce techniquement faisable, auditer la faisabilité, vérifier la cohérence avec l'archi.
argument-hint: <chemin-relatif-ou-absolu-vers-le-brouillon dans output/>
---

**Pré-vol :**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "Vault non configuré. Définir CORPUS_VAULT (dev local) ou configurer l'option utilisateur vaultPath dans le plugin installé (exposée sous CLAUDE_PLUGIN_OPTION_VAULT_PATH). Ni l'un ni l'autre n'est défini. Lancez /init-vault <chemin> pour initialiser un vault, puis exportez le chemin." >&2
  exit 1
fi
```

Vérifier que `$CORPUS_VAULT/.corpus-vault` existe. Sinon, refuser et demander au propriétaire de lancer `/init-vault <chemin>`. Voir `corpus-core/rules/08-vault-structure.md`.

**Validation de l'argument :**

`$ARGUMENTS` doit être fourni. Si absent, afficher :

```
Usage : /pm-review-feasibility <chemin-vers-brouillon>
Le chemin peut être absolu ou relatif à $CORPUS_VAULT/output/.
Exemple : /pm-review-feasibility output/2026-04-28-ma-feature-prd.md
```

et s'arrêter.

Résoudre le chemin du brouillon :

- Si `$ARGUMENTS` est un chemin absolu, l'utiliser tel quel.
- Sinon, le résoudre sous `$CORPUS_VAULT/output/` : `$CORPUS_VAULT/output/$ARGUMENTS` (supprimer le préfixe `output/` s'il est déjà présent).

Vérifier que le fichier résolu existe et se trouve bien sous `$CORPUS_VAULT/output/`. Si le fichier n'existe pas ou est en dehors de `output/`, refuser avec un message explicite.

**Délégation :**

Invoquer la skill **corpus-pm:review-feasibility** (voir `corpus-pm/skills/review-feasibility/SKILL.md`) en lui passant le chemin absolu résolu du brouillon.

La skill s'occupe de :
1. Lire le brouillon et identifier les claims techniques.
2. Scanner `wiki/decision-*` et `wiki/feature-*` pour chaque claim.
3. Détecter les conflits entre le brouillon et les décisions d'architecture documentées.
4. Produire l'analyse en quatre axes : faisabilité des claims, dépendances, risques d'intégration, décisions contredites.
5. Écrire la page de stress-test dans `$CORPUS_VAULT/wiki/stress-test-<draft-slug>-feasibility-<YYYY-MM-DD>.md`.
6. Appendre l'entrée dans `wiki/log.md`.

**Contrainte anti-lissage :** si le wiki ne contient aucune page `decision-*`, la skill doit refuser avec un arrêt dur et orienter le propriétaire vers `/ingest`. Elle ne doit jamais inventer des décisions d'architecture ou des contraintes techniques absentes du wiki.

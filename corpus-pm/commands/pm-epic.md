---
description: Décompose un PRD en epic + issues enfants dans beads (délègue au pm-decomposer)
argument-hint: <chemin-relatif-ou-absolu-vers-le-PRD dans output/>
---

**Pré-vol :**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "Vault non configuré. Définir CORPUS_VAULT (dev local) ou configurer l'option userConfig vaultPath dans le plugin installé (exposée comme CLAUDE_PLUGIN_OPTION_VAULT_PATH). Ni l'un ni l'autre n'est défini. Lancer /init-vault <path> pour créer un vault, puis exporter le chemin." >&2
  exit 1
fi
```

Vérifier que `$CORPUS_VAULT/.corpus-vault` existe. Sinon, refuser et demander à l'utilisateur de lancer `/init-vault <path>`.

**Validation de l'argument :**

`$ARGUMENTS` doit être fourni. Si absent, afficher :

```
Usage : /pm-epic <chemin-vers-prd>
Le chemin peut être absolu ou relatif à $CORPUS_VAULT/output/.
Exemple : /pm-epic output/2024-01-15-feature-search.md
```

et s'arrêter.

Résoudre le chemin du PRD :

- Si `$ARGUMENTS` est un chemin absolu, l'utiliser tel quel.
- Sinon, le résoudre sous `$CORPUS_VAULT/output/` : `$CORPUS_VAULT/output/$ARGUMENTS` (supprimer le préfixe `output/` s'il est déjà présent).

Vérifier que le fichier résolu existe et se trouve bien sous `$CORPUS_VAULT/output/`. Si le fichier n'existe pas ou est en dehors de `output/`, refuser avec un message explicite.

**Délégation :**

Déléguer au sous-agent **pm-decomposer** (voir `corpus-pm/agents/pm-decomposer.md`) en lui passant le chemin absolu résolu du PRD.

Le sous-agent s'occupe de :
1. Lire et parser le PRD.
2. Créer l'epic dans beads via `bd create`.
3. Créer une issue enfant par exigence P0/P1 via `bd create`.
4. Lier chaque enfant à l'epic via `bd dep add`.
5. Afficher le récapitulatif final (epic ID, IDs enfants, chemin PRD).

**Contrainte anti-lissage :** le sous-agent doit refuser de créer une issue si les critères d'acceptation sont absents pour une exigence P0. Ne jamais inventer des critères.

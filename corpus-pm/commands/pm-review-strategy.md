---
description: Stress-teste un brouillon (PRD, roadmap ou autre output/) sous l'angle stratégie/périmètre et dépose un stress-test dans wiki/
argument-hint: <chemin-relatif-ou-absolu-vers-le-brouillon dans output/>
---

**Pré-vol :**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "Vault non configuré. Définir CORPUS_VAULT (dev local) ou configurer l'option utilisateur vaultPath dans le plugin installé (exposée comme CLAUDE_PLUGIN_OPTION_VAULT_PATH). Ni l'un ni l'autre n'est défini. Lancer /init-vault <chemin> pour initialiser un vault, puis exporter le chemin." >&2
  exit 1
fi
```

Vérifier que `$CORPUS_VAULT/.corpus-vault` existe. Sinon, refuser et demander au propriétaire de lancer `/init-vault <chemin>`. Voir `corpus-core/rules/08-vault-structure.md`.

**Validation de l'argument :**

`$ARGUMENTS` doit être fourni. Si absent, afficher :

```
Usage : /pm-review-strategy <chemin-vers-brouillon>
Le chemin peut être absolu ou relatif à $CORPUS_VAULT/output/.
Exemple : /pm-review-strategy output/2026-04-28-ma-feature-prd.md
```

et s'arrêter.

Résoudre le chemin du brouillon :

- Si `$ARGUMENTS` est un chemin absolu, l'utiliser tel quel.
- Sinon, le résoudre sous `$CORPUS_VAULT/output/` : `$CORPUS_VAULT/output/$ARGUMENTS` (supprimer le préfixe `output/` s'il est déjà présent).

Vérifier que le fichier résolu existe et se trouve bien sous `$CORPUS_VAULT/output/`. Si le fichier n'existe pas ou est en dehors de `output/`, refuser avec un message explicite.

**Délégation :**

Déléguer au sous-agent **pm-strategist** (voir `corpus-pm/agents/pm-strategist.md`) en lui passant le chemin absolu résolu du brouillon.

Le sous-agent s'occupe de :
1. Lire le brouillon.
2. Scanner `wiki/decision-*` et `wiki/feature-*`.
3. Analyser les quatre angles : périmètre, séquencement, coût d'opportunité, décisions contredites.
4. Déposer la page de stress-test dans `$CORPUS_VAULT/wiki/stress-test-<draft-slug>-strategy-<YYYY-MM-DD>.md`.
5. Mettre à jour `wiki/log.md`.

**Contrainte anti-lissage :** si le wiki ne contient aucune page `decision-*` ni `feature-*`, le sous-agent doit refuser avec un arrêt dur et orienter le propriétaire vers `/ingest`. Il ne doit jamais inventer des décisions ou des éléments de roadmap absents du wiki.

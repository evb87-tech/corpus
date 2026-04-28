---
description: Stress-teste un draft (PRD ou autre output/) sous l'angle recherche utilisateur — personas servis/non servis, verbatims contradictoires, niveau de confiance par claim
argument-hint: <chemin-relatif-ou-absolu-vers-le-draft dans output/>
---

**Pré-vol :**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "Vault non configuré. Définir CORPUS_VAULT (dev local) ou configurer l'option utilisateur vaultPath dans le plugin installé (exposée sous CLAUDE_PLUGIN_OPTION_VAULT_PATH). Ni l'un ni l'autre n'est défini. Lancez /init-vault <chemin> pour initialiser un vault, puis exportez le chemin." >&2
  exit 1
fi
```

Vérifiez que `$CORPUS_VAULT/.corpus-vault` existe. Si absent, refusez et indiquez au propriétaire de lancer `/init-vault <chemin>`. Voir `corpus-core/rules/08-vault-structure.md`.

**Validation de l'argument :**

`$ARGUMENTS` doit être fourni. Si absent, afficher :

```
Usage : /pm-review-user <chemin-vers-draft>
Le chemin peut être absolu ou relatif à $CORPUS_VAULT/output/.
Exemple : /pm-review-user output/2026-04-28-feature-notifications-prd.md
```

et s'arrêter.

Résoudre le chemin du draft :

- Si `$ARGUMENTS` est un chemin absolu, l'utiliser tel quel.
- Sinon, le résoudre sous `$CORPUS_VAULT/output/` : `$CORPUS_VAULT/output/$ARGUMENTS` (supprimer le préfixe `output/` s'il est déjà présent).

Vérifier que le fichier résolu existe et se trouve bien sous `$CORPUS_VAULT/output/`. Si le fichier n'existe pas ou est en dehors de `output/`, refuser avec un message explicite.

**Délégation :**

Déléguer au sous-agent **pm-user-advocate** (voir `corpus-pm/agents/pm-user-advocate.md`) en lui passant le chemin absolu résolu du draft.

Le sous-agent s'occupe de :
1. Lire le draft et identifier les claims utilisateur.
2. Scanner `wiki/persona-*` et `wiki/interview-*` pour chaque claim.
3. Produire l'analyse en quatre axes : personas servis, personas non servis, verbatims contradictoires, niveau de confiance.
4. Écrire la page de stress-test dans `$CORPUS_VAULT/wiki/stress-test-<draft-slug>-user-<YYYY-MM-DD>.md`.
5. Appendre l'entrée dans `wiki/log.md`.

**Contrainte anti-lissage :** si le wiki ne contient aucune page `persona-*` ni `interview-*`, le sous-agent doit refuser avec un arrêt total et pointer vers `/ingest`. Il ne doit jamais inventer des personas ou des verbatims.

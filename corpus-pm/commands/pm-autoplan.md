---
description: Orchestre les trois angles de revue (stratégie, utilisateur, faisabilité) en parallèle, puis synthétise leurs pages de stress-test dans output/
argument-hint: <chemin-relatif-ou-absolu-vers-le-brouillon dans output/>
---

**Pré-vol :**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "Vault non configuré. Définir CORPUS_VAULT (dev local) ou configurer l'option utilisateur vaultPath dans le plugin installé (exposée sous CLAUDE_PLUGIN_OPTION_VAULT_PATH). Ni l'un ni l'autre n'est défini. Lancer /init-vault <chemin> pour initialiser un vault, puis exporter le chemin." >&2
  exit 1
fi
```

Vérifier que `$CORPUS_VAULT/.corpus-vault` existe. Sinon, refuser et demander au propriétaire de lancer `/init-vault <chemin>`. Voir `corpus-core/rules/08-vault-structure.md`.

**Validation de l'argument :**

`$ARGUMENTS` doit être fourni. Si absent, afficher :

```
Usage : /pm-autoplan <chemin-vers-brouillon>
Le chemin peut être absolu ou relatif à $CORPUS_VAULT/output/.
Exemple : /pm-autoplan output/2026-04-28-feature-notifications-prd.md
```

et s'arrêter.

Résoudre le chemin du brouillon :

- Si `$ARGUMENTS` est un chemin absolu, l'utiliser tel quel.
- Sinon, le résoudre sous `$CORPUS_VAULT/output/` : `$CORPUS_VAULT/output/$ARGUMENTS` (supprimer le préfixe `output/` s'il est déjà présent).

Vérifier que le fichier résolu existe et se trouve bien sous `$CORPUS_VAULT/output/`. Si le fichier n'existe pas ou est en dehors de `output/`, refuser avec un message explicite.

**Dériver le slug du brouillon :**

```bash
DRAFT_BASENAME=$(basename "$DRAFT_PATH" .md)
DRAFT_SLUG=$(echo "$DRAFT_BASENAME" | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//')
TODAY=$(date +%Y-%m-%d)
```

**Orchestration des trois angles :**

Lancer les trois revues en parallèle (ou dans le même tour de contexte si le parallélisme n'est pas disponible) en déléguant à chaque commande existante :

1. `/pm-review-strategy <chemin-absolu-du-brouillon>` — délègue à l'agent `pm-strategist`
2. `/pm-review-user <chemin-absolu-du-brouillon>` — délègue à l'agent `pm-user-advocate`
3. `/pm-review-feasibility <chemin-absolu-du-brouillon>` — délègue à la skill `corpus-pm:review-feasibility`

Chaque revue dépose sa page de stress-test dans `$CORPUS_VAULT/wiki/` selon les conventions :
- Stratégie : `wiki/stress-test-<draft-slug>-strategy-<YYYY-MM-DD>.md`
- Utilisateur : `wiki/stress-test-<draft-slug>-user-<YYYY-MM-DD>.md`
- Faisabilité : `wiki/stress-test-<draft-slug>-feasibility-<YYYY-MM-DD>.md`

**Vérification des pages produites :**

Avant de passer à la synthèse, vérifier que les trois pages de stress-test existent :

```bash
STRATEGY_PAGE="$CORPUS_VAULT/wiki/stress-test-${DRAFT_SLUG}-strategy-${TODAY}.md"
USER_PAGE="$CORPUS_VAULT/wiki/stress-test-${DRAFT_SLUG}-user-${TODAY}.md"
FEASIBILITY_PAGE="$CORPUS_VAULT/wiki/stress-test-${DRAFT_SLUG}-feasibility-${TODAY}.md"
```

Si l'une ou plusieurs pages sont absentes, refuser de procéder à la synthèse et afficher :

```
ARRÊT : Les pages de stress-test suivantes sont manquantes :
  - [liste des pages absentes]
La synthèse /pm-autoplan ne peut pas être produite avec des revues partielles.
Corrigez les erreurs signalées par les revues manquantes, puis relancez /pm-autoplan.
```

**Délégation de la synthèse :**

Une fois les trois pages confirmées, invoquer la skill **corpus-pm:pm-autoplan-synthesis** en lui passant :

- Le chemin absolu du brouillon
- Les chemins absolus des trois pages de stress-test
- Le slug du brouillon
- La date du jour

La skill produit `output/YYYY-MM-DD-autoplan-<draft-slug>.md` selon les règles anti-lissage (règle 5 en particulier) et les contraintes de synthèse détaillées dans la skill.

**Quand terminé, rapporter :**

- Chemin du brouillon analysé
- Pages de stress-test produites (liste avec angle)
- Chemin de la synthèse produite
- Nombre de conflits inter-angles détectés
- Lacunes signalées dans la synthèse

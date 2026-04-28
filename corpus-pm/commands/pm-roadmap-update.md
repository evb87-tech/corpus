---
description: Produit un document de roadmap dans output/ à partir des epics beads + des pages wiki/decision-*
argument-hint: "[titre ou périmètre — ex. : Q2 orienté clients]"
---

**Pré-vol :**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "Vault non configuré. Définissez CORPUS_VAULT (dev local) ou configurez l'option utilisateur vaultPath dans le plugin installé (exposée sous CLAUDE_PLUGIN_OPTION_VAULT_PATH). Ni l'un ni l'autre n'est défini. Lancez /init-vault <chemin> pour initialiser un vault, puis exportez le chemin." >&2
  exit 1
fi
```

Vérifiez que `$CORPUS_VAULT/.corpus-vault` existe. Si absent, refusez et indiquez au propriétaire de lancer `/init-vault <chemin>`. Voir `corpus-core/rules/08-vault-structure.md`.

Titre ou périmètre optionnel : $ARGUMENTS

Invoquez la skill `corpus-pm:roadmap-update` pour produire la roadmap. Le préfixe `corpus-pm:` est obligatoire : Claude Code namespace toujours les skills par plugin et ne résout pas les noms nus, même quand la commande et la skill sont dans le même plugin. Toutes les instructions de lecture, de structuration des sections, de citation et de signalement des lacunes se trouvent dans la skill.

Chemins : tous relatifs à `$CORPUS_VAULT`.

**Quand terminé, rapportez :**

- Chemin du fichier roadmap produit
- Epics listés par statut (en cours / prochain / bloqué)
- Pages wiki citées (liste)
- Lacunes signalées (sections marquées `[non vérifié]` ou vides par absence de données)

---
description: Pression-teste une idée produit à l'heure de bureau (office hours) — positionnement, personas, contexte concurrentiel, chaque recommandation citée dans le wiki. Triggers — brainstormer une idée produit, tester une idée de feature, challenger un concept avant la spec.
argument-hint: <idée produit en texte libre>
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

**Validation de l'argument :**

`$ARGUMENTS` doit être fourni. Si absent, afficher :

```
Usage : /pm-brainstorm <idée produit>
Décrivez l'idée en texte libre. Exemple : /pm-brainstorm notifications push pour les utilisateurs mobiles inactifs
```

et s'arrêter.

Idée à tester : $ARGUMENTS

Invoquez la skill `corpus-pm:brainstorm` pour conduire la séance de pression-test. Le préfixe `corpus-pm:` est obligatoire : Claude Code namespace toujours les skills par plugin et ne résout pas les noms nus, même quand la commande et la skill sont dans le même plugin. Toutes les instructions d'analyse, la taxonomie des axes, les règles de citation et le comportement de signalement des lacunes se trouvent dans la skill.

Chemins : tous relatifs à `$CORPUS_VAULT`.

**Quand terminé, rapportez :**

- Chemin du fichier brainstorm produit dans `output/`
- Pages wiki citées (liste)
- Lacunes signalées (dimensions sans données wiki)
- Verdict de la séance (idée renforcée / affaiblie / incertaine)

---
description: Rédige un PRD (Product Requirements Document) dans output/ à partir des entités du wiki. Triggers — écrire un PRD, rédiger une spec produit, produire un brief produit basé sur les entités wiki.
argument-hint: <nom de la fonctionnalité>
---

**Pré-vol :**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "Aucun vault configuré. Définissez CORPUS_VAULT (dev local) ou configurez l'option utilisateur vaultPath dans le plugin installé (exposée sous CLAUDE_PLUGIN_OPTION_VAULT_PATH). Aucune des deux n'est définie. Lancez /init-vault <chemin> pour initialiser un vault, puis exportez le chemin." >&2
  exit 1
fi
```

Vérifiez que `$CORPUS_VAULT/.corpus-vault` existe. Si absent, refusez et indiquez au propriétaire de lancer `/init-vault <chemin>`. Voir `corpus-core/rules/08-vault-structure.md`.

Fonctionnalité à spécifier : $ARGUMENTS

Invoquez la skill `corpus-pm:feature-spec` pour rédiger le PRD. Le préfixe `corpus-pm:` est obligatoire : Claude Code namespace toujours les skills par plugin et ne résout pas les noms nus, même quand la commande et la skill sont dans le même plugin. Toutes les instructions de rédaction, la taxonomie des sections, les règles de citation et le comportement de signalement des lacunes se trouvent dans la skill.

Chemins : tous relatifs à `$CORPUS_VAULT`.

**Collecte des entités wiki :**

1. Lisez `wiki/index.md` pour identifier les pages pertinentes.
2. Collectez dans cet ordre de priorité :
   - `Glob $CORPUS_VAULT/wiki/persona-*.md` — personas affectés
   - `Glob $CORPUS_VAULT/wiki/competitor-*.md` — concurrents pour le positionnement
   - `Glob $CORPUS_VAULT/wiki/decision-*.md` — engagements préalables
   - `Glob $CORPUS_VAULT/wiki/feature-*.md` — fonctionnalités connexes
3. Lisez chaque page trouvée en entier avant de rédiger.

**Sortie :**

- Fichier de sortie : `output/YYYY-MM-DD-<slug>-prd.md`
  - `YYYY-MM-DD` = date du jour (ISO 8601)
  - `<slug>` = version kebab-case ASCII de `$ARGUMENTS` (minuscules, sans accents, sans caractères spéciaux)
- N'écrivez jamais dans `wiki/` ni dans `raw/`.

**Quand terminé, rapportez :**

- Chemin du fichier PRD produit
- Pages wiki citées (liste)
- Lacunes signalées (sections marquées `[non vérifié]` ou mises en attente)

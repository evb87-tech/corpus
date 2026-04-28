# Mon vault corpus

Ce répertoire est un **vault corpus** — un second cerveau structuré, géré par des agents LLM.

## Dossiers

| Dossier | Rôle | Qui écrit |
|---------|------|-----------|
| `raw/` | Sources brutes capturées par le propriétaire | Propriétaire uniquement |
| `wiki/` | Pages compilées par entité, en français | Agents uniquement |
| `output/` | Livrables : notes de synthèse, briefs, décisions | Propriétaire |
| `.obsidian/` | Configuration Obsidian locale | Obsidian |

## Invariants

- **`raw/` est en lecture seule pour les agents.** Déposez vos sources ; les agents ne les modifient jamais.
- **`wiki/` est en écriture exclusive pour les agents.** Si vous éditez manuellement une page wiki, signalez-le avant de relancer un ingest.
- **`output/` n'alimente jamais `wiki/`.** Le wiki enregistre ce que disent les sources. L'output enregistre ce que vous en concluez.

## Démarrage

```bash
export CORPUS_VAULT="$(pwd)"
/ingest raw/ma-source.md
/query research "ma question"
```

Voir la documentation du plugin : [corpus-core](https://github.com/your-org/corpus).

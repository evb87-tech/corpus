---
type: skill-trigger-audit
date: 2026-04-28
audience: native-fr
scope: corpus-core slash commands
---

# Audit de déclenchement — corpus-core (5 commandes)

> Quality gate avant le partage communautaire (cor-acd). Pour chaque commande,
> on vérifie : (1) trigger accuracy sur des phrasings FR réalistes, (2) absence
> d'over-triggering sur des phrasings adjacents, (3) qualité du `description:`
> pour la sélection skill par Claude (mécanisme de trigger primaire).
>
> Rule: chaque description doit contenir les mots-clés FR que l'audience PM/data
> tape réellement. Une description EN-only sous-trigger sur un prompt FR.

---

## /init-vault

**Description actuelle (EN) :** « Scaffold a fresh corpus vault at the given path »

**Prompts FR réalistes :**

1. « initialise un nouveau vault corpus dans ~/notes »
2. « j'aimerais créer un vault corpus à partir de zéro »
3. « scaffolde-moi un dossier vault corpus à /Users/evb/Documents/corpus-perso »

**Prédiction de trigger :** maybe / maybe / yes
- Prompt 1 : « initialise » et « vault » sont absents de la description EN. Risque sous-trigger.
- Prompt 2 : « créer un vault à partir de zéro » sémantiquement proche de « scaffold a fresh vault », mais bilingue.
- Prompt 3 : « scaffolde » est une francisation directe — bon match.

**Over-trigger check :** « initialise un nouveau projet Vue.js » ne doit PAS déclencher. Description EN trop générique sur « scaffold ».

**Recommandation :** ajouter trigger FR explicite. Inclure « initialiser », « vault corpus », « second cerveau ».

---

## /ingest

**Description actuelle (EN) :** « Ingest a source from $CORPUS_VAULT/raw into the vault's wiki (delegates to the ingester subagent) »

**Prompts FR réalistes :**

1. « ajoute cette source au wiki » (drop d'un PDF dans raw/)
2. « ingère le fichier raw/interview-marie-2026-03.md »
3. « digère ce nouveau document que je viens de déposer »

**Prédiction de trigger :** maybe / yes / maybe
- Prompt 1 : « ajoute au wiki » est sémantiquement /ingest, mais le mot « ingest » EN n'est pas dans le prompt FR.
- Prompt 2 : « ingère » est francisation directe, et « raw/ » donne un signal fort.
- Prompt 3 : « digère » est un quasi-synonyme rare. Sous-trigger probable.

**Over-trigger check :** « ajoute cette ligne au CSV » ne doit PAS déclencher (mot « ajoute » ambigu sans « wiki »).

**Recommandation :** description FR/EN. Ajouter triggers : « ingérer », « digérer une source », « ajouter au wiki », « source dans raw/ ».

---

## /query

**Description actuelle (EN) :** « Query the wiki under one of three postures — research, contradictor, synthesis »

**Prompts FR réalistes :**

1. « qu'est-ce que le wiki dit sur la dette produit ? »
2. « interroge le wiki en mode contradicteur sur ma roadmap Q2 »
3. « cherche dans le wiki ce qu'on sait de Notion comme concurrent »

**Prédiction de trigger :** maybe / yes / maybe
- Prompt 1 : « le wiki dit sur » est très naturel — devrait matcher mais pas de mot « query ».
- Prompt 2 : « interroge le wiki en mode contradicteur » contient « contradicteur » qui matche directement.
- Prompt 3 : « cherche dans le wiki » est sémantique de query, mais aucun mot anglais.

**Over-trigger check :** « cherche dans mes notes » sans wiki ne doit PAS matcher. OK car « wiki » obligatoire.

**Recommandation :** ajouter triggers FR : « interroger le wiki », « consulter le wiki », « rechercher », « contredire », « synthétiser ». Garder les noms de postures EN (`research|contradictor|synthesis`) car ils sont l'argument littéral.

---

## /check

**Description actuelle (EN) :** « Run a structural + content-level lint pass over the wiki »

**Prompts FR réalistes :**

1. « vérifie la cohérence du wiki »
2. « lance un check de qualité sur le wiki »
3. « audite le wiki — y a-t-il des liens cassés ou des contradictions oubliées ? »

**Prédiction de trigger :** maybe / yes / maybe
- Prompt 1 : « vérifie la cohérence » est sémantique de lint, mais aucun mot EN.
- Prompt 2 : « check » comme emprunt direct — bon match.
- Prompt 3 : « audite » est sémantique mais sous-représenté dans une description EN.

**Over-trigger check :** « vérifie ce code Python » ne doit PAS matcher. Description actuelle est suffisamment spécifique au wiki.

**Recommandation :** ajouter triggers FR : « vérifier la cohérence du wiki », « auditer le wiki », « linter le wiki », « détecter les liens brisés et contradictions ».

---

## /draft

**Description actuelle (EN) :** « Draft an output document, pulling from the wiki »

**Prompts FR réalistes :**

1. « rédige-moi un brief de présentation à partir du wiki »
2. « draft un document sur la discovery produit en piochant dans le wiki »
3. « écris un livrable qui synthétise ce que le wiki sait sur les personas »

**Prédiction de trigger :** maybe / yes / maybe
- Prompt 1 : « rédige » est sémantique mais EN-only description sous-trigger.
- Prompt 2 : « draft » comme verbe FR — bon match.
- Prompt 3 : « écris un livrable » + « synthétise » + « wiki » — sémantique fort, mais pas matché par EN.

**Over-trigger check :** « rédige un email » sans wiki ne doit PAS matcher. OK car la description impose « pulling from the wiki ».

**Recommandation :** ajouter triggers FR : « rédiger », « draft un document », « produire un livrable », « générer un brief à partir du wiki ».

---

## Synthèse corpus-core

**Constat global :** les 5 descriptions sont en EN-only. L'audience FR triggera de façon dégradée — le LLM bilingue compense partiellement, mais pas systématiquement, surtout sur des prompts courts (« vérifie le wiki », « ajoute cette source »).

**Action recommandée :** rendre chaque description bilingue (EN + FR). Les fragments FR ajoutés ne doivent pas dupliquer la sémantique mais multiplier les surfaces d'accroche. Format : `<description EN>. Trigger FR : <verbe1>, <verbe2>, <expression-tirée-de-l'usage-réel>.`

Voir le commit qui suit pour les modifications appliquées.

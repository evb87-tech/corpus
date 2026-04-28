---
type: skill-trigger-audit
date: 2026-04-28
audience: native-fr
scope: corpus-pm slash commands + skills
---

# Audit de déclenchement — corpus-pm (7 commandes + 4 skills)

> Quality gate avant le partage communautaire (cor-acd). Pour chaque
> commande/skill, on vérifie : (1) trigger accuracy sur des phrasings FR
> réalistes, (2) absence d'over-triggering, (3) qualité du `description:`
> pour la sélection skill par Claude.
>
> Les descriptions corpus-pm sont déjà en FR — c'est un bon point de départ.
> L'audit cherche les sous-triggers (phrasings naturels non couverts) et les
> over-triggers (champs trop larges qui prendraient des prompts adjacents).

---

## /pm-spec

**Description actuelle :** « Rédige un PRD (Product Requirements Document) dans output/ à partir des entités du wiki »

**Prompts FR réalistes :**

1. « écris-moi un PRD pour la feature digest intelligent »
2. « rédige une spec produit à partir de ce qu'on sait dans le wiki sur les notifications »
3. « génère un brief produit pour ma proposition de journal des décisions »

**Prédiction de trigger :** yes / yes / maybe
- Prompt 1 : « PRD » présent dans la description — match direct.
- Prompt 2 : « rédige une spec produit » sémantique fort — devrait matcher (« rédige » est dans la description).
- Prompt 3 : « brief produit » est ambigu (peut être /draft ou /pm-spec). Risque sous-trigger sur /pm-spec spécifiquement.

**Over-trigger check :** « écris un PRD pour mon side-project Vue » ne doit PAS forcément matcher si CORPUS_VAULT n'est pas pertinent. La description ne le précise pas — risque modéré.

**Recommandation :** ajouter trigger « spec produit », « brief produit ». Préciser « basé sur les entités wiki » pour éviter over-trigger hors-vault.

---

## /pm-epic

**Description actuelle :** « Décompose un PRD en epic + issues enfants dans beads (délègue au pm-decomposer) »

**Prompts FR réalistes :**

1. « transforme ce PRD en epic beads »
2. « décompose ma spec en tickets actionnables »
3. « crée les issues enfants pour cette feature à partir du PRD »

**Prédiction de trigger :** yes / yes / yes
- Tous trois contiennent un mot fort présent dans la description (« décompose », « PRD », « epic », « issues »).

**Over-trigger check :** « décompose ce nombre en facteurs premiers » ne doit PAS matcher. OK car le contexte « PRD/beads » est bien spécifié.

**Recommandation :** description suffisante. Ajouter optionnellement « tickets » comme synonyme d'« issues » pour les utilisateurs Linear/Jira. Très bon trigger surface globalement.

---

## /pm-review-strategy

**Description actuelle :** « Stress-teste un brouillon (PRD, roadmap ou autre output/) sous l'angle stratégie/périmètre et dépose un stress-test dans wiki/ »

**Prompts FR réalistes :**

1. « attaque mon PRD sous l'angle stratégie »
2. « est-ce que cette feature reste dans notre périmètre ? challenge-la »
3. « stress-teste ma roadmap Q2 stratégiquement »

**Prédiction de trigger :** yes / maybe / yes
- Prompt 1 : « attaque » + « stratégie » — match direct sur « stress-teste » + « stratégie ».
- Prompt 2 : « challenge » est anglicisme courant en FR PM. « périmètre » match « périmètre » de la description.
- Prompt 3 : « stress-teste » + « stratégiquement » — match très fort.

**Over-trigger check :** « stress-teste ce code » sans contexte produit ne doit PAS matcher. Description impose « PRD, roadmap ou autre output/ » — bonne contrainte.

**Recommandation :** ajouter trigger « attaquer », « challenger » comme synonymes de « stress-teste ».

---

## /pm-review-user

**Description actuelle :** « Stress-teste un draft (PRD ou autre output/) sous l'angle recherche utilisateur — personas servis/non servis, verbatims contradictoires, niveau de confiance par claim »

**Prompts FR réalistes :**

1. « est-ce que ce PRD sert tous nos personas ? »
2. « critique cette spec du point de vue user research »
3. « attaque mon draft sous l'angle persona »

**Prédiction de trigger :** yes / maybe / yes
- Prompt 1 : « personas » match directement.
- Prompt 2 : « user research » est anglais, « critique » est FR, « spec » match « PRD » sémantiquement. Trigger probable mais pas garanti.
- Prompt 3 : « persona » + « attaque » — sémantique très clair.

**Over-trigger check :** « critique ce design d'interface utilisateur » ne doit PAS forcément déclencher /pm-review-user — c'est plutôt /design-review hypothétique. Bordure floue.

**Recommandation :** ajouter trigger « critiquer », « recherche utilisateur », « point de vue persona ». Préciser que c'est un PRD/brouillon produit, pas de l'UX/UI.

---

## /pm-review-feasibility

**Description actuelle :** « Stress-teste un brouillon (PRD, roadmap ou autre output/) sous l'angle faisabilité technique — claims de complexité, dépendances, risques d'intégration et décisions d'architecture antérieures »

**Prompts FR réalistes :**

1. « est-ce que c'est techniquement faisable ce qu'on propose dans ce PRD ? »
2. « audite la faisabilité de ma roadmap »
3. « est-ce que cette feature contredit nos décisions d'archi passées ? »

**Prédiction de trigger :** yes / yes / yes
- Tous trois matchent directement sur « faisabilité », « décisions d'architecture », « PRD/roadmap ».

**Over-trigger check :** « est-ce techniquement possible » sans contexte produit pourrait matcher. Description impose « PRD, roadmap » — OK.

**Recommandation :** description très bonne. Ajouter « techniquement faisable » comme expression directe. Trigger surface couvre déjà bien.

---

## /pm-roadmap-update

**Description actuelle :** « Produit un document de roadmap dans output/ à partir des epics beads + des pages wiki/decision-* »

**Prompts FR réalistes :**

1. « update ma roadmap avec l'état actuel des beads »
2. « génère une nouvelle roadmap Q2 »
3. « produis un doc roadmap qui croise les epics et les décisions wiki »

**Prédiction de trigger :** yes / maybe / yes
- Prompt 1 : « roadmap » + « beads » — match direct.
- Prompt 2 : « nouvelle roadmap Q2 » sémantique mais ne mentionne pas explicitement les beads ou le wiki. Trigger possible mais pas certain.
- Prompt 3 : matche très bien la description littérale.

**Over-trigger check :** « génère une roadmap pour mon side-project » sans beads ne doit PAS matcher. Description impose « beads + wiki ».

**Recommandation :** ajouter « rafraîchir », « mettre à jour la roadmap » pour le cas trimestriel.

---

## /pm-brainstorm

**Description actuelle :** « Pression-teste une idée produit à l'heure de bureau — positionnement, personas, contexte concurrentiel, chaque recommandation citée dans le wiki »

**Prompts FR réalistes :**

1. « j'ai une idée de feature, brainstormons-la »
2. « pression-teste cette idée d'onboarding interactif »
3. « est-ce que cette idée tient la route en office hours ? »

**Prédiction de trigger :** maybe / yes / yes
- Prompt 1 : « brainstormons » est sémantique mais le mot exact « brainstorm » n'est pas dans la description (c'est dans le nom de la commande). Risque sous-trigger.
- Prompt 2 : « pression-teste » match direct.
- Prompt 3 : « office hours » est dans la description (« heure de bureau »).

**Over-trigger check :** « brainstorme avec moi sur des noms de produit » sans wiki ne doit PAS forcément matcher /pm-brainstorm. Risque modéré — la description impose « citée dans le wiki ».

**Recommandation :** ajouter trigger « brainstormer », « tester une idée produit », « idée » au sens large.

---

## Skills (4)

Les 4 skills ont des descriptions en FR plus longues que les commandes. Audit rapide :

### brainstorm (skill)

**Description :** « Pression-teste une idée produit sur trois axes — positionnement + décisions passées, personas gagnants/perdants, différenciation concurrentielle. Chaque claim est cité dans le wiki. Ne complète jamais avec des connaissances d'entraînement. Produit un rapport dans output/. »

**Verdict :** description forte, anti-lissage explicite. Triggers FR couverts : « pression-teste », « idée produit », « positionnement », « personas », « concurrents ».
**Recommandation :** ajouter « brainstormer » comme verbe d'entrée — c'est l'expression naturelle FR la plus courante quand un PM lance une session.

### feature-spec (skill)

**Description :** « Rédige un PRD structuré (Product Requirements Document) en français à partir des entités wiki — personas, concurrents, décisions, fonctionnalités connexes. Applique les règles anti-lissage : ne jamais inventer de persona ou de concurrent absent du wiki, signaler toute lacune explicitement. »

**Verdict :** très bonne description. Triggers FR : « rédige un PRD », « spec », « entités wiki ».
**Recommandation :** description suffisante. Optionnellement ajouter « brief produit » comme synonyme.

### review-feasibility (skill)

**Description :** « Stress-teste un brouillon (PRD ou roadmap) sous l'angle faisabilité technique. Croise les claims techniques du brouillon avec les pages wiki/decision-* et wiki/feature-* pour surfaces les conflits avec l'architecture documentée. Conçue pour un propriétaire côté produit qui prépare une discussion ingénierie. Applique les règles anti-lissage — refuse si aucune décision n'existe au wiki. »

**Verdict :** description forte avec contexte d'usage explicite. Triggers FR : « stress-teste », « faisabilité », « architecture ».
**Recommandation :** ajouter « techniquement faisable » comme expression directe.

> Typo notée : « surfaces les conflits » devrait être « surfacer les conflits ». À corriger.

### roadmap-update (skill)

**Description :** « Produit un document de roadmap dans output/ en croisant l'état actuel des epics beads avec les décisions et priorités documentées dans le wiki. Applique les règles anti-lissage — ne jamais compléter avec des connaissances d'entraînement, citer le wiki pour chaque affirmation de scope ou de priorité. »

**Verdict :** très bonne description.
**Recommandation :** rien de critique. Optionnellement ajouter « rafraîchir la roadmap ».

---

## Synthèse corpus-pm

**Constat global :** les 7 commandes et 4 skills sont en FR — bon ancrage pour l'audience. Sous-triggers les plus probables :
1. /pm-brainstorm sur « brainstormons » (verbe FR le plus naturel manquant)
2. /pm-spec sur « brief produit » et « spec produit »
3. /pm-roadmap-update sur « update ma roadmap » seul

**Over-trigger principal :** /pm-review-user qui pourrait être pris pour /design-review hypothétique. Préciser le scope.

**Typo à corriger :** review-feasibility skill, « surfaces » → « surfacer ».

Les modifications de descriptions appliquées dans le commit suivant ciblent ces sous-triggers.

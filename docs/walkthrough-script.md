# Walkthrough vidéo — corpus-core + corpus-pm

Script voiceover + shot list pour la vidéo de présentation du moteur corpus-core et du pack PM corpus-pm.
Durée cible : 9–10 minutes. Cadence de tournage : shot par shot, dans l'ordre.

---

## Pré-vol — préparer le vault de démo avant tournage

Exécuter une fois **avant de commencer à filmer**. Le vault doit être dans cet état exact au début du shot 1.

### Ce que le vault ne doit PAS encore contenir

- Aucun dossier `~/Documents/demo-corpus` (ou le supprimer : `rm -rf ~/Documents/demo-corpus`).
- `CORPUS_VAULT` non exporté dans le shell de tournage.

### Sources à préparer dans un dossier staging (ex. `~/Desktop/sources-demo/`)

Créer **quatre** fichiers avant tournage (le quatrième est nouveau — nécessaire pour la démo PM) :

| Fichier | Type recommandé | Contenu suggéré |
|---|---|---|
| `karpathy-llm-wiki.md` | Markdown | Résumé du gist LLM-wiki de Karpathy (2–3 paragraphes, EN). Coller depuis le gist public. |
| `critique-pkm-llm.md` | Markdown | Article court (EN ou FR) critiquant les approches PKM à base de LLM — ex. risque de lissage, de sur-résumé. 2–3 paragraphes suffisent. |
| `note-personnelle-second-brain.md` | Markdown | Note personnelle (FR, voix du propriétaire) sur pourquoi un second cerveau curé. Utiliser la première personne. Doit contenir au moins une formule singulière que l'agent ne devra pas lisser. |
| `interview-pm-alice-2026-04.md` | Markdown | Transcript (simulé) d'un entretien utilisateur avec une PM fictive (Alice, PM senior). Doit contenir des verbatims directs entre guillemets, des frictions explicites avec les outils de PKM actuels, et au moins un besoin exprimé autour de la traçabilité des décisions produit. Environ 15–20 lignes suffisent. |

Ces quatre fichiers génèrent assez de matière pour produire 4–6 pages wiki, dont au moins une contradiction visible entre `karpathy-llm-wiki.md` et `critique-pkm-llm.md`, et une page `interview-*` que `/pm-review-user` pourra citer dans le shot 12.

> **Note au caméraman :** les fichiers exacts n'ont pas d'importance ; ce qui compte c'est qu'au moins deux sources prennent des positions divergentes sur le même concept (ex. "les LLM améliorent la PKM" vs. "les LLM lissent la PKM"). La contradiction doit être visible dans `wiki/` pour le shot 7. Et l'interview doit contenir des verbatims exploitables par le stress-test du shot 12.

---

## Script et shot list

### Shot 1 — Hook (0:00–0:30)

**Frame focus :** terminal propre, fond noir, pas de fichiers ouverts.

**VO (FR) :**
> On passe beaucoup de temps à lire. Des articles, des gists, des threads. Et à la fin… on ne sait plus ce qu'on a lu, ni ce qu'on en pensait vraiment. Les outils de prise de notes résument, synthétisent, lissent — et effacent exactement ce qui était singulier dans nos lectures.
>
> corpus est un moteur différent. Il compile vos sources en un wiki curé par Claude, dans votre langue, avec vos contradictions préservées. Pas de synthèse automatique. Pas d'invention. Ce que vos sources disent, et rien d'autre.

**Action :** aucune. Plan fixe sur le terminal vide ou le bureau.

---

### Shot 2 — Installation du plugin (0:30–0:55)

**Frame focus :** terminal.

**VO (FR) :**
> corpus s'installe en deux commandes depuis Claude Code. Le moteur de base s'appelle corpus-core. corpus-pm est le pack use-case orienté gestion de produit — on l'installe en même temps.

**Action — taper dans le terminal :**
```
/plugin marketplace add evb87-tech/corpus
/plugin install corpus-core@corpus
/plugin install corpus-pm@corpus
```

**Frame focus :** sortie terminal montrant la confirmation d'installation des deux plugins.

> **TODO (dry run) :** vérifier que la sortie d'installation est lisible et non-ambiguë avant tournage. Si la commande demande une confirmation interactive, noter ici la touche à presser. Vérifier que `corpus-pm@corpus` résout correctement depuis le marketplace.

---

### Shot 3 — /init-vault (0:55–1:45)

**Frame focus :** terminal.

**VO (FR) :**
> Une fois le plugin installé, on crée un vault — c'est le dossier séparé qui va contenir toutes vos sources et toutes les pages wiki. Le moteur et le vault sont deux choses distinctes. Votre contenu ne vit jamais dans le repo du moteur.

**Action — taper dans le terminal :**
```
/init-vault ~/Documents/demo-corpus
```

**VO (FR) :**
> La commande crée la structure : `raw/` pour vos sources, `wiki/` pour les pages compilées, `output/` pour vos livrables, et un dossier `.obsidian/` déjà configuré. Un marqueur `.corpus-vault` rend le dossier reconnaissable par le moteur.

**VO (FR) :**
> Le moteur a besoin de savoir où vit votre vault. Deux options : exporter `CORPUS_VAULT` dans votre shell **avant** de lancer Claude Code, ou configurer l'option `vaultPath` du plugin. La variable lue à l'intérieur d'une session déjà ouverte ne se propagera pas aux slash commands suivantes — il faut donc le faire dans le shell parent ou via l'UI du plugin.

**Action — quitter Claude Code (Ctrl+C ou /exit), puis dans le shell parent :**
```
export CORPUS_VAULT=~/Documents/demo-corpus
echo 'export CORPUS_VAULT=~/Documents/demo-corpus' >> ~/.zshrc   # persist
claude
```

**Frame focus :** terminal pendant la sortie + relance, puis Claude Code redémarré dans la session avec le vault configuré.

**TODO (dry run) :** vérifier exactement comment l'option `vaultPath` se configure côté plugin — si une commande Claude Code la rend manipulable sans relancer le shell, préférer cette voie pour la démo (un cut au montage suffit).

**VO (FR) :**
> La variable est maintenant visible par toutes les commandes du moteur. Si elle n'est pas définie, les commandes refusent de s'exécuter — c'est voulu.

**Action :** ouvrir le Finder ou un explorateur de fichiers montrant la structure créée.

**Frame focus :** arborescence du vault dans Finder : `raw/`, `wiki/`, `output/`, `.obsidian/`, `.corpus-vault`.

---

### Shot 4 — Déposer des sources (1:45–2:15)

**Frame focus :** Finder / glisser-déposer.

**VO (FR) :**
> Maintenant on dépose des sources dans `raw/`. Ce dossier est en lecture seule pour les agents — eux ne peuvent pas y écrire. C'est vous qui décidez ce qui entre.

**Action :** glisser les quatre fichiers de `~/Desktop/sources-demo/` vers `~/Documents/demo-corpus/raw/` dans le Finder.

**Frame focus :** `raw/` maintenant peuplé de quatre fichiers `.md`.

**VO (FR) :**
> Quatre fichiers pour cette démo : un résumé du pattern LLM-wiki de Karpathy, une critique de ce pattern, une note personnelle — et un transcript d'entretien utilisateur avec Alice, une PM senior. Ce dernier fichier alimentera les commandes PM plus loin dans la démo.

---

### Shot 5 — /ingest (2:15–3:30)

**Frame focus :** terminal.

**VO (FR) :**
> On lance l'ingestion. Sans argument, la commande traite tous les fichiers de `raw/` qui n'ont pas encore été ingérés.

**Action — taper dans le terminal :**
```
/ingest
```

**VO (FR) :**
> Le moteur délègue à l'agent ingester. Il lit chaque source, extrait les entités — personnes, concepts, entreprises, frameworks — et compile une page par entité dans `wiki/`. Le contenu est traduit en français si la source est en anglais. Les citations verbatim restent dans la langue d'origine. Et si deux sources se contredisent, le moteur ne tranche pas — il préserve le conflit.

**Frame focus :** sortie terminal de l'agent ingester (rapport : pages créées, pages modifiées, contradictions détectées).

**VO (FR) :**
> À la fin, le moteur rapporte ce qu'il a produit : pages créées, pages mises à jour, contradictions détectées. Ici on voit qu'une contradiction a été signalée entre deux sources sur le même concept.

> **TODO (dry run) :** vérifier que la sortie de `/ingest` est suffisamment lisible à l'écran pour être filmée. Si elle défile trop vite, envisager de filmer la sortie finale uniquement.

---

### Shot 6 — Ouvrir une page wiki (3:30–4:15)

**Frame focus :** éditeur de texte (ou Obsidian en mode preview).

**VO (FR) :**
> Regardons une page produite. Chaque page a un frontmatter structuré : le type de l'entité, les sources qui l'alimentent, la date de dernière mise à jour.

**Action :** ouvrir l'une des pages wiki générées dans `wiki/` — par exemple `wiki/llm-wiki.md` ou la page la plus substantielle produite.

**Frame focus :** frontmatter de la page (`type:`, `sources:`, `last_updated:`).

**VO (FR) :**
> Puis le corps de la page en français : un résumé discriminant, ce que disent les sources point par point, les connexions vers d'autres pages via des wikilinks, et — le point clé — la section Contradictions, qui liste explicitement les conflits entre sources sans les résoudre.

**Frame focus :** faire défiler jusqu'à la section `## Contradictions` de la page.

---

### Shot 7 — /check (4:15–5:00)

**Frame focus :** terminal.

**VO (FR) :**
> Le moteur embarque une commande de maintenance : `/check`. Elle passe un lint complet sur le wiki — liens brisés, pages orphelines, pages périmées, frontmatter manquant — mais aussi une relecture de contenu : concepts importants sans page, affirmations qui méritent une investigation.

**Action — taper dans le terminal :**
```
/check
```

**Frame focus :** sortie terminal du librarian (rapport structurel + content-level).

**VO (FR) :**
> La commande est en lecture seule. Elle rapporte, elle ne corrige pas. C'est vous qui décidez quoi faire des résultats. Ici on voit les questions ouvertes que le wiki ne peut pas encore répondre — un signal sur ce qu'il faudrait lire ensuite.

> **TODO (dry run) :** s'assurer que le vault de démo produit au moins un avertissement ou une question ouverte intéressante pour rendre ce shot non-trivial.

---

### Shot 8 — /query contradictor (5:00–6:00)

**Frame focus :** terminal.

**VO (FR) :**
> On peut interroger le wiki sous trois postures différentes. La posture research récupère ce que les sources disent. La posture synthesis produit une moyenne statistique — mais dans `output/`, pas dans le wiki, pour éviter de contaminer le corpus avec une opinion lissée.
>
> La posture la plus puissante est contradictor. On demande au moteur d'attaquer le wiki — de trouver les angles morts, les hypothèses cachées, les arguments faibles.

**Action — taper dans le terminal :**
```
/query contradictor Le pattern LLM-wiki résout-il vraiment le problème du lissage ?
```

**Frame focus :** sortie terminal de l'agent contradictor — liste de contre-arguments, pages où l'évidence est mince.

**VO (FR) :**
> Le résultat est filé en retour dans le wiki comme une page de type stress-test. Ce n'est pas une note de l'auteur, c'est une page structurée qui rend les faiblesses visibles et consultables. Le wiki se renforce en archivant ses propres angles morts.

**Frame focus :** page `type: stress-test` créée dans `wiki/`.

> **TODO (dry run) :** adapter la question à l'angle de contradiction effectivement présent dans vos sources de démo. La question doit correspondre au vrai conflit entre `karpathy-llm-wiki.md` et `critique-pkm-llm.md`.

---

### Shot 9 — Obsidian : graph view (6:00–6:50)

**Frame focus :** Obsidian — Graph View.

**VO (FR) :**
> Le vault est un dossier Obsidian standard. On l'ouvre directement. La configuration `.obsidian/` livrée avec le vault active le Graph View et le panneau Properties — les deux vues utiles pour un wiki d'entités.

**Action :** ouvrir Obsidian, ouvrir le vault `demo-corpus` (File > Open Vault > demo-corpus).

**Action :** ouvrir le Graph View (icône graphe dans la barre latérale, ou `Ctrl+G` / `Cmd+G`).

**Frame focus :** graph view montrant les nœuds (pages) et les arêtes (wikilinks). La page stress-test doit être visible et connectée.

**VO (FR) :**
> Chaque nœud est une page wiki. Les arêtes sont les wikilinks — `[[page]]` dans le markdown. Les pages les plus connectées sont les concepts centraux de vos lectures. La page stress-test aparaît connectée aux pages qu'elle attaque.

> **TODO (dry run) :** vérifier que le graph view Obsidian se génère correctement sur le vault de démo avec le nombre de pages produit. Si le graph est trop sparse, ajouter une source supplémentaire avant tournage. Vérifier aussi que la couleur ou la forme des nœuds stress-test est distinguable — sinon noter ici que le graph view ne le distingue pas.

---

### Shot 10 — Obsidian : panneau Properties (6:50–7:20)

**Frame focus :** Obsidian — une page wiki ouverte avec le panneau Properties visible.

**Action :** dans Obsidian, ouvrir une page wiki entity (ex. `llm-wiki.md`) en mode lecture ou aperçu live.

**Action :** ouvrir le panneau Properties (View > Properties, ou en cliquant sur les trois points en haut de la page).

**Frame focus :** panneau Properties montrant `type:`, `sources:` (liste de fichiers), `last_updated:`.

**VO (FR) :**
> Le panneau Properties d'Obsidian lit le frontmatter YAML de chaque page. `type` indique la nature de l'entité. `sources` liste les fichiers de `raw/` qui ont alimenté cette page — c'est la traçabilité complète. `last_updated` permet de repérer les pages qui n'ont pas été revisitées depuis longtemps.

**VO (FR) :**
> Ces champs sont indexables par Dataview si vous installez le plugin communautaire. Mais le moteur lui-même ne dépend d'aucun plugin — le vault reste lisible comme du markdown ordinaire par n'importe quel outil.

---

### Shot 11 — /pm-spec : rédiger le PRD (7:20–8:10)

**Frame focus :** terminal.

**VO (FR) :**
> corpus-pm est le premier pack use-case. Il s'installe en même temps que corpus-core — il suffit d'ajouter une ligne lors de l'installation du plugin. Ses commandes opèrent sur le même vault. La première commande PM : `/pm-spec`. On lui donne le nom d'une fonctionnalité, et elle produit un PRD complet dans `output/`, ancré dans les entités du wiki.

**Action — taper dans le terminal :**
```
/pm-spec export des décisions vers Notion
```

**VO (FR) :**
> La commande délègue à l'agent feature-spec. Celui-ci commence par scanner le wiki : pages `persona-*`, `competitor-*`, `decision-*`, `feature-*`. Pour chaque section du PRD — Problème, User stories, Exigences, Critères d'acceptation, Métriques de succès — il cite les pages wiki qui supportent le contenu. Si une section ne peut pas être étayée, il la marque explicitement comme lacune plutôt que de l'inventer.

**Frame focus :** sortie terminal montrant les pages wiki lues, puis le chemin du fichier produit.

**VO (FR) :**
> Le PRD est déposé dans `output/` avec la date du jour dans le nom : `output/2026-04-28-export-des-decisions-vers-notion-prd.md`. Chaque section contient des références wiki entre doubles crochets — `[[wiki/persona-alice-pm]]` — qui sont des liens Obsidian cliquables. La section `Sources wiki` à la fin liste exhaustivement les pages consultées et les lacunes signalées.

**Frame focus :** ouvrir le fichier PRD dans l'éditeur — frontmatter (`type: prd`, `status: draft`), puis faire défiler rapidement jusqu'à la section `## User stories` et `## Sources wiki`.

> **Note :** `/pm-spec` lit les pages `persona-*`, `competitor-*`, `decision-*` et `feature-*` du wiki — pas les pages `interview-*`. Pour que les User stories soient étayées, il faut que l'ingestion de `interview-pm-alice-2026-04.md` ait produit une page `wiki/persona-alice-pm.md` (l'ingester extrait les personas des transcripts d'entretien). C'est cette page persona, pas l'interview directement, que `/pm-spec` citera.

> **TODO (dry run) :** vérifier que l'ingestion du shot 5 a bien produit une page `wiki/persona-*.md` à partir de `interview-pm-alice-2026-04.md`. Si l'ingester ne crée pas de page persona (par exemple s'il crée seulement une page `interview-*`), il faudra soit ajuster le contenu de l'interview pour qu'il soit plus explicite sur le profil du locuteur, soit déposer séparément une fiche persona dans `raw/`.

---

### Shot 12 — /pm-review-user : stress-test utilisateur (8:10–8:55)

**Frame focus :** terminal.

**VO (FR) :**
> Le PRD est un brouillon. Avant de l'exposer à l'équipe, `/pm-review-user` le stress-teste sous l'angle de la recherche utilisateur. La commande prend le chemin du PRD en argument et délègue au sous-agent pm-user-advocate.

**Action — taper dans le terminal :**
```
/pm-review-user output/2026-04-28-export-des-decisions-vers-notion-prd.md
```

**VO (FR) :**
> Le sous-agent lit le PRD, identifie tous les claims utilisateur, puis les croise avec les pages `persona-*` et `interview-*` du wiki. Il produit une analyse en quatre axes : quels personas sont servis, quels personas sont ignorés, quels verbatims du wiki contredisent les claims du PRD, et quel est le niveau de confiance de chaque claim — fort, moyen, faible, ou non documenté.

**Frame focus :** sortie terminal du sous-agent — rapport structuré montrant les personas et le tableau de confiance.

**VO (FR) :**
> Le résultat est écrit comme page wiki de type `stress-test` : `wiki/stress-test-2026-04-28-export-des-decisions-vers-notion-prd-user-2026-04-28.md`. Cette page n'est pas une opinion — c'est une archive structurée des angles morts du PRD, citant les verbatims mot pour mot depuis les pages `interview-*` du wiki. On voit ici qu'Alice a dit exactement : « Je perds une heure par sprint à chercher pourquoi une décision a été prise. » — un claim que le PRD sous-exploite.
>
> Si le wiki ne contenait aucune page `persona-*` ni `interview-*`, le sous-agent aurait refusé d'opérer plutôt que d'inventer des personas. C'est la règle anti-lissage en action.

**Frame focus :** ouvrir la page stress-test dans l'éditeur — section `## Verbatims contradictoires` et tableau `## Niveau de confiance par claim`.

> **TODO (dry run) :** vérifier que l'interview ingérée contient bien des verbatims directs et que la page `wiki/interview-pm-alice-2026-04.md` a une section `## Verbatims` remplie après ingestion. Sans verbatims, le sous-agent le signale comme lacune — utile à montrer mais moins spectaculaire.

---

### Shot 13 — /pm-epic : décomposer en tâches beads (8:55–9:35)

**Frame focus :** terminal.

**VO (FR) :**
> Le PRD est validé sous l'angle utilisateur. On passe à l'exécution : `/pm-epic` décompose le PRD en issues dans beads — l'outil de gestion de tickets intégré à l'environnement de développement. La commande crée un epic parent et une issue enfant par exigence P0 et P1.

**Action — taper dans le terminal :**
```
/pm-epic output/2026-04-28-export-des-decisions-vers-notion-prd.md
```

**VO (FR) :**
> Le sous-agent pm-decomposer parse le PRD : titre, problème, objectifs, exigences, critères d'acceptation. Avant de créer quoi que ce soit, il vérifie que chaque exigence P0 a ses critères d'acceptation. Si un critère P0 manque, il s'arrête et refuse de créer des issues incomplètes — encore une fois, anti-lissage.

**Frame focus :** sortie terminal — récapitulatif final : ID de l'epic, IDs des issues enfants, liens de dépendance.

**VO (FR) :**
> Le récapitulatif affiche l'epic créé — appelons-le `COR-42` — et ses issues enfants liées : `COR-43` pour l'export OAuth, `COR-44` pour le mapping des décisions wiki vers les propriétés Notion. Chaque issue contient une note `PRD: [[2026-04-28-export-des-decisions-vers-notion-prd]]` pour la traçabilité. Les issues P2, jugées différables, sont ignorées par l'agent — seules les P0 et P1 entrent dans le backlog.

> **Note technique :** le format des exigences dans le PRD produit par `/pm-spec` (`- [P0] description`) et le format attendu par `pm-decomposer` (`### P0 — libellé`) peuvent diverger selon la version du SKILL. Vérifier avant tournage que le decomposer identifie bien les blocs P0/P1 dans le PRD généré — sinon le dry run du shot 13 aboutira à zéro issue créée.

> **TODO (dry run) :** vérifier que `bd create`, `bd dep add` et `bd lint` sont disponibles et fonctionnels dans l'environnement de tournage. Vérifier que le format des exigences dans le PRD produit (shot 11) est reconnu par le decomposer. Si beads n'est pas installé, le sous-agent échouera au premier appel `bd create` — prévoir dans ce cas une variante en mode simulation.

---

### Shot 14 — bd ready : fermer la boucle (9:35–10:00)

**Frame focus :** terminal.

**VO (FR) :**
> La boucle est fermée. En une commande beads, on voit le travail maintenant disponible.

**Action — taper dans le terminal :**
```
bd ready
```

**Frame focus :** sortie de `bd ready` — liste des issues sans bloqueurs ouverts sur ce projet.

**VO (FR) :**
> L'epic `COR-42` apparaît disponible — il n'est pas bloqué par une dépendance externe. Un développeur peut le réclamer avec `bd update COR-42 --claim` et commencer à travailler sur la coordination globale. Les issues enfants `COR-43` et `COR-44` ont été créées avec une dépendance sur l'epic : elles ne seront pleinement visibles comme débloquées qu'une fois l'epic marqué comme en cours ou fermé selon la politique du projet — ce que le VO ou le plan de tournage doit ajuster selon le comportement réel observé en dry run.
>
> Voilà ce que corpus fait en moins de dix minutes : un vault structuré, des sources ingérées en pages wiki françaises, les contradictions préservées, un PRD ancré dans la recherche utilisateur, un stress-test anti-lissage, et un backlog beads structuré prêt à l'exécution.

**Action :** aucune. Plan fixe.

---

### Shot 15 — Wrap (10:00–10:20)

**Frame focus :** terminal ou bureau propre.

**VO (FR) :**
> Le moteur ne synthétise pas à votre place. Il ne comble pas les silences avec ses connaissances d'entraînement. Il ne lisse pas les positions contradictoires. Ce qu'il fait, c'est archiver ce que vous avez lu, avec la fidélité d'un greffier — et transformer ces archives en livrables PM traçables.
>
> Le vault vous appartient — c'est un dossier git privé. Le moteur est open source. Et les deux ne se mélangent jamais.
>
> corpus-core est le moteur. corpus-pm est le premier pack use-case. Les deux s'installent depuis Claude Code. Liens dans la description.

**Action :** aucune. Plan fixe.

---

## Notes de réalisation

- **Résolution recommandée :** 1920×1080 minimum. Le terminal doit être lisible — agrandir la police à 16 pt minimum avant tournage.
- **Couleur du terminal :** fond sombre conseillé pour le contraste avec la sortie agent.
- **Obsidian :** fermer les panneaux non nécessaires (Daily Notes, Tags) avant les shots 9–10 pour ne montrer que Graph View et Properties.
- **Vitesse de frappe :** taper les commandes lentement et distinctement. Faire une pause d'une seconde après chaque `Entrée` avant de continuer le VO.
- **Montage :** les shots 5, 8, 11 et 12 peuvent nécessiter un cut si l'agent prend plus de 20 secondes. Prévoir une version accélérée (2×) de la sortie terminal pour ces shots.
- **Sous-titres :** le VO est en français. Ajouter des sous-titres FR pour l'accessibilité et pour les contextes audio-off.
- **Shot 11 :** les IDs d'issues beads (`COR-42`, `COR-43`, `COR-44`) sont des exemples fictifs dans le script. Les IDs réels produits lors du tournage peuvent différer — les substituer en post-prod dans les sous-titres si nécessaire. L'essentiel est que la structure epic + enfants soit visible à l'écran.
- **Shot 12 :** le verbatim cité dans le VO (« Je perds une heure par sprint à chercher pourquoi une décision a été prise. ») doit figurer mot pour mot dans `interview-pm-alice-2026-04.md` pour que la démo soit honnête. Si le fichier d'interview est modifié avant tournage, ajuster le VO en conséquence.

---

## TODO — dry runs non validés de bout en bout

Les points suivants n'ont pas été validés par une exécution réelle dans un vault de démo. Ils doivent faire l'objet d'un dry run avant tournage.

1. **Shot 2 — Installation corpus-pm :** vérifier que `/plugin install corpus-pm@corpus` résout correctement depuis le marketplace et que les deux plugins s'installent sans conflits. Vérifier la sortie terminale (interactivité, confirmations).
2. **Shot 5 — Ingestion de l'interview :** vérifier que `/ingest` sur `interview-pm-alice-2026-04.md` produit une page `wiki/interview-pm-alice-2026-04.md` avec un champ `## Verbatims` non vide. Sans verbatims ingérés, le shot 12 sera moins démonstratif.
3. **Shot 11 — /pm-spec avec wiki peuplé :** vérifier que l'ingestion des quatre sources produit suffisamment de pages `persona-*` et/ou `interview-*` pour que `/pm-spec` puisse rédiger les sections User stories et Problème sans les marquer toutes en lacune. Ajuster le contenu de l'interview si nécessaire.
4. **Shot 12 — /pm-review-user :** vérifier que le sous-agent pm-user-advocate produit une page stress-test dans `wiki/` avec le nom exact attendu (`stress-test-2026-04-28-export-des-decisions-vers-notion-prd-user-2026-04-28.md`), que la section `## Verbatims contradictoires` contient au moins un verbatim citant la page `[[wiki/interview-pm-alice-2026-04]]`, et que le tableau `## Niveau de confiance par claim` est rempli.
5. **Shot 13 — /pm-epic format des exigences :** `feature-spec` (skill de `/pm-spec`) génère les exigences sous forme de liste `- [P0] description`, mais `pm-decomposer` cherche des blocs `### P0 —`. Vérifier que le decomposer identifie bien les exigences dans le PRD réellement produit ; si ce n'est pas le cas, le script doit noter que zéro issue sera créée jusqu'à la correction du format.
6. **Shot 13 — /pm-epic beads :** vérifier que `bd` est installé et accessible dans le shell de tournage. Vérifier que `bd create --type epic`, `bd create --type task`, `bd dep add`, et `bd lint` fonctionnent. Si beads n'est pas disponible, prévoir une variante où le sous-agent affiche uniquement le plan des issues sans les créer (mode simulation).
7. **Shot 14 — bd ready et direction des dépendances :** avec `bd dep add <CHILD> <EPIC>`, les issues enfants ont l'epic comme dépendance (elles sont bloquées par l'epic, pas l'inverse). Vérifier le comportement réel de `bd ready` dans l'environnement de tournage et ajuster le VO pour décrire fidèlement quelles issues apparaissent débloquées et dans quel ordre.

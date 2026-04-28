# Walkthrough vidéo — corpus-core

Script voiceover + shot list pour la vidéo de présentation du moteur corpus-core.
Durée cible : 7–8 minutes. Cadence de tournage : shot par shot, dans l'ordre.

---

## Pré-vol — préparer le vault de démo avant tournage

Exécuter une fois **avant de commencer à filmer**. Le vault doit être dans cet état exact au début du shot 1.

### Ce que le vault ne doit PAS encore contenir

- Aucun dossier `~/Documents/demo-corpus` (ou le supprimer : `rm -rf ~/Documents/demo-corpus`).
- `CORPUS_VAULT` non exporté dans le shell de tournage.

### Sources à préparer dans un dossier staging (ex. `~/Desktop/sources-demo/`)

Créer trois fichiers avant tournage :

| Fichier | Type recommandé | Contenu suggéré |
|---|---|---|
| `karpathy-llm-wiki.md` | Markdown | Résumé du gist LLM-wiki de Karpathy (2–3 paragraphes, EN). Coller depuis le gist public. |
| `critique-pkm-llm.md` | Markdown | Article court (EN ou FR) critiquant les approches PKM à base de LLM — ex. risque de lissage, de sur-résumé. 2–3 paragraphes suffisent. |
| `note-personnelle-second-brain.md` | Markdown | Note personnelle (FR, voix du propriétaire) sur pourquoi un second cerveau curé. Utiliser la première personne. Doit contenir au moins une formule singulière que l'agent ne devra pas lisser. |

Ces trois fichiers génèrent assez de matière pour produire 3–5 pages wiki, dont au moins une contradiction visible entre `karpathy-llm-wiki.md` et `critique-pkm-llm.md`.

> **Note au caméraman :** les fichiers exacts n'ont pas d'importance ; ce qui compte c'est qu'au moins deux sources prennent des positions divergentes sur le même concept (ex. "les LLM améliorent la PKM" vs. "les LLM lissent la PKM"). La contradiction doit être visible dans `wiki/` pour le shot 7.

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
> corpus s'installe en une commande depuis Claude Code. Le moteur de base s'appelle corpus-core.

**Action — taper dans le terminal :**
```
/plugin marketplace add evb87-tech/corpus
/plugin install corpus-core@corpus
```

**Frame focus :** sortie terminal montrant la confirmation d'installation.

> **TODO (dry run) :** vérifier que la sortie d'installation est lisible et non-ambiguë avant tournage. Si la commande demande une confirmation interactive, noter ici la touche à presser.

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

**Action :** glisser les trois fichiers de `~/Desktop/sources-demo/` vers `~/Documents/demo-corpus/raw/` dans le Finder.

**Frame focus :** `raw/` maintenant peuplé de trois fichiers `.md`.

**VO (FR) :**
> Trois fichiers suffisent pour cette démo : un résumé du pattern LLM-wiki de Karpathy, une critique de ce pattern, et une note personnelle. On va voir ce que le moteur en fait.

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

### Shot 11 — Wrap (7:20–8:00)

**Frame focus :** terminal ou bureau propre.

**VO (FR) :**
> Voilà ce que corpus fait en moins de dix minutes : un vault structuré, des sources ingérées en pages wiki françaises, les contradictions préservées, un lint de maintenance, une attaque contradictor — et une vue graphe dans Obsidian.
>
> Le moteur ne synthétise pas à votre place. Il ne comble pas les silences avec ses connaissances d'entraînement. Il ne lisse pas les positions contradictoires. Ce qu'il fait, c'est archiver ce que vous avez lu, avec la fidélité d'un greffier.
>
> Le vault vous appartient — c'est un dossier git privé. Le moteur est open source. Et les deux ne se mélangent jamais.

**Action :** aucune. Plan fixe.

**VO (FR) :**
> corpus-core est le moteur. corpus-pm est le premier pack use-case, orienté gestion de produit. Les deux s'installent depuis Claude Code. Liens dans la description.

---

## Notes de réalisation

- **Résolution recommandée :** 1920×1080 minimum. Le terminal doit être lisible — agrandir la police à 16 pt minimum avant tournage.
- **Couleur du terminal :** fond sombre conseillé pour le contraste avec la sortie agent.
- **Obsidian :** fermer les panneaux non nécessaires (Daily Notes, Tags) avant les shots 9–10 pour ne montrer que Graph View et Properties.
- **Vitesse de frappe :** taper les commandes lentement et distinctement. Faire une pause d'une seconde après chaque `Entrée` avant de continuer le VO.
- **Montage :** les shots 5 et 8 peuvent nécessiter un cut si l'agent prend plus de 20 secondes. Prévoir une version accélérée (2×) de la sortie terminal pour ces deux shots.
- **Sous-titres :** le VO est en français. Ajouter des sous-titres FR pour l'accessibilité et pour les contextes audio-off.

---
eval: pm-epic-edge-vague-metrics
command: /pm-epic
type: edge-case
audience: native-fr
suppresses: anti-lissage §2
---

## Scénario

Un PRD est disponible dans `output/`. Il contient une section `## Métriques de succès`
(donc le pm-decomposer ne refuse pas) mais les métriques sont vagues et non mesurables
(ex. : « améliorer la satisfaction utilisateur »). Les exigences P0 ont des critères
d'acceptation. Le comportement attendu est que l'epic est créé avec les métriques
telles quelles, mais que le récapitulatif final signale que les métriques sont vagues
et pourraient ne pas passer `bd lint`. Le pm-decomposer ne les réécrit pas.

## Setup

Créer le PRD de test dans `output/` :

**`output/2026-04-28-feature-commentaires-prd.md`** (voir `evals/fixtures/pm-epic-prd-edge.md`)

Structure attendue du PRD (extraits pertinents) :

```markdown
# Commentaires collaboratifs sur les décisions

## Exigences

### P0 — Ajout de commentaires
Un utilisateur peut ajouter un commentaire textuel à une décision.

### P1 — Mentions
Un utilisateur peut @mentionner un collègue dans un commentaire.

## Critères d'acceptation
- P0 Commentaires : le commentaire s'affiche sous la décision en < 500 ms.
- P1 Mentions : la @mention envoie une notification email dans < 1 min.

## Métriques de succès
- Améliorer la satisfaction utilisateur sur la collaboration.
- Augmenter l'engagement avec les décisions passées.
```

## Prompt

```
/pm-epic output/2026-04-28-feature-commentaires-prd.md
```

## Pass criteria (rubric)

- L'epic est créé (le pm-decomposer ne refuse pas car la section `## Métriques de
  succès` existe).
- La section `## Success Criteria` de l'epic contient les métriques telles quelles
  (verbatim), sans réécriture ni amélioration.
- Le récapitulatif final ou le résultat de `bd lint` signale que les métriques sont
  vagues ou potentiellement non conformes aux critères de `bd lint`.
- Les issues enfants P0 et P1 sont créées avec leurs critères respectifs.
- Aucune métrique n'est inventée ou précisée par le pm-decomposer pour compléter les
  métriques vagues — violation §2.
- Les enfants sont liés à l'epic.

## Fail signals

- Le pm-decomposer refuse de créer l'epic au prétexte que les métriques sont vagues
  (il ne refuse que si la section `## Métriques de succès` est absente, pas si elle
  est vague).
- Le pm-decomposer réécrit les métriques pour les rendre mesurables (ex. : ajoute un
  chiffre cible) — invention de critères, violation §2.
- L'epic est créé sans signalement de la faiblesse des métriques dans le récapitulatif.
- Les issues enfants ne correspondent pas aux exigences P0/P1 du PRD.

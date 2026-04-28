---
type: competitor
sources: [raw/competitor-scan-2026-01.md]
last_updated: 2026-03-01
last-observed: 2026-01-18
---

# AlertFlow

## Résumé

AlertFlow est un concurrent direct sur le segment DevOps/SRE mid-market. Positionné comme alternative à PagerDuty pour les entreprises qui trouvent PagerDuty trop cher ou trop complexe. Leur force principale est un log de routage auditable par alerte — ils ont résolu le problème d'auditabilité que nos personas exigent. Leur faiblesse : pas de digest, règles ML non éditables par l'utilisateur.

## Ce que disent les sources

D'après raw/competitor-scan-2026-01.md : AlertFlow est fondé en 2021, basé à Berlin, financé en Série A (€12M, Q3 2025). Tarification : €299–€999/mois, seat-based au-dessus de 25 utilisateurs. Intégrations natives : PagerDuty/OpsGenie migration, GitHub Actions, Datadog.

D'après raw/competitor-scan-2026-01.md : Leur log de routage par alerte est cité positivement dans les avis G2. C'est leur proposition de valeur différenciante sur l'auditabilité. Cependant, l'utilisateur ne peut pas modifier le modèle ML — il peut voir les décisions mais pas les règles sous-jacentes.

D'après raw/competitor-scan-2026-01.md : Les avis G2 (42 reviews, 4.1/5) mentionnent systématiquement une courbe d'apprentissage steep pour le setup des règles. Ce n'est pas un produit "plug and play."

D'après raw/competitor-scan-2026-01.md : AlertFlow n'a pas de fonctionnalité de digest — uniquement du routage. La combinaison routage + digest n'est donc pas couverte par ce concurrent.

## Connexions

- [[wiki/segment-firefighters-devops]] : segment cible principal d'AlertFlow
- [[wiki/competitor-digestbot]] : concurrent sur l'autre dimension (digest sans routage)
- [[wiki/feature-digest-intelligent]] : fonctionnalité non couverte par AlertFlow — différenciateur potentiel

## Contradictions

Aucune contradiction inter-sources sur AlertFlow (une seule source).

## Questions ouvertes

- AlertFlow a-t-il annoncé une feuille de route vers le digest ? [non documenté dans la source]
- Leur focus Berlin/marché allemand est-il structurel (tech stack, partenariats) ou opportuniste ? Impact sur la stratégie de go-to-market France.
- Que signifie "steep learning curve for rule setup" dans les avis G2 — est-ce l'interface ou le modèle mental requis ?

## Positionnement

"The intelligent incident bridge." Upgrade de PagerDuty pour le mid-market (50–500 personnes). Pitch : ML-based on-call routing avec log auditable.

## Forces

- Log de routage par alerte : auditabilité documentée et appréciée en G2.
- Intégrations PagerDuty/OpsGenie : migration facile depuis les outils en place.
- Intégrations Datadog et GitHub Actions (native, pas webhook-only).
- Bien financé (Série A €12M) — runway pour 18 mois minimum.

## Faiblesses

- Pas de digest — uniquement routage. Manque la moitié du problème (bruit hors incidents).
- Règles ML non éditables : l'utilisateur voit le log mais ne peut pas modifier la logique. Bloquerait Luc.
- Courbe de setup steep : 3 semaines de configuration mentionnées dans G2.
- Focus marché allemand — friction potentielle pour la vente en France.

## Last observed

2026-01-18 (source : raw/competitor-scan-2026-01.md)

## Sources

- [[raw/competitor-scan-2026-01.md]]

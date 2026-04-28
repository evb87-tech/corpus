# Agent architectures — three readings

Source: reading sprint notes, April 2024

**Source A (article de recherche)** : Les architectures multi-agents avec orchestrateur
central surpassent les agents monolithiques sur des tâches de raisonnement décomposable.
Le gain principal vient de la réduction de la longueur de contexte par agent.

**Source B (post de praticien)** : En production, la latence des orchestrateurs
multi-agents est rédhibitoire. Les auteurs rapportent des temps de réponse 4–8x
supérieurs à un agent unique pour des tâches comparables.

**Source C (note personnelle)** : Le débat agent unique vs. multi-agents me semble
mal posé. La vraie question est : quelle granularité de décomposition de tâche
correspond à la structure du problème ?

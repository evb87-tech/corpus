# Notes de lecture — article mixte EN/FR

Source: notes de séminaire, janvier 2024

L'article distingue deux régimes d'apprentissage : le pré-entraînement, qui construit
les capacités générales, et le fine-tuning, qui les oriente vers une tâche.

The key finding: "Fine-tuning on fewer than 1 000 examples can steer behavior on a
narrow task, but the pretrained representations dominate on out-of-distribution inputs."

Ce résultat remet en question l'idée que le fine-tuning est une solution universelle
pour l'adaptation à un domaine. Les auteurs recommandent de commencer par le prompting,
puis le few-shot, avant de recourir au fine-tuning.

Author note: "The boundary between 'task adaptation' and 'capability degradation' is
not well defined in the literature."

# Scaling laws and data quality

Source: reading note, March 2024

The original Chinchilla paper established that optimal training compute should be split
roughly equally between model parameters and training tokens. A 70 B parameter model
is optimally trained on approximately 1.4 T tokens under this regime.

One contested implication: the Chinchilla result was derived under a fixed compute budget.
It does not say anything about quality filtering of training data, only about the
quantity-to-parameter ratio.

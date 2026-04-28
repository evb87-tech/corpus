# Context length and model memory — a practitioner's view

Source: internal note, April 2024

Long-context models do not solve the memory problem. Attention over a 128 k token window
degrades toward the middle; empirical results on synthetic recall tasks show a U-shaped
retention curve, with strong recall at the beginning and end of the window and poor recall
for material buried in the middle third.

The practical upshot: do not rely on long context as a substitute for structured retrieval.
Index first, retrieve second.

Author: practitioner note (owner-authored)

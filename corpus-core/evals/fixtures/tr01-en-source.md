# Retrieval-augmented generation — practical limits

Source: blog post reading notes, February 2024

RAG pipelines decompose into three failure modes: chunking errors (the relevant passage
spans a chunk boundary), embedding drift (the query and the passage use different
vocabularies), and re-ranking failure (the top-k retrieved passages are plausible but
not relevant).

The author's recommendation: "Treat RAG as a fallback, not a foundation. Build first
with long context; add retrieval only where latency or cost forces it."

Evaluation note: most published RAG benchmarks test single-hop retrieval. Multi-hop
reasoning — where the answer requires chaining two retrieved passages — remains an
unsolved problem at production scale.
